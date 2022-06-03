## [CPD22-7a] COMPONENTI DEL GRUPPO
## Gabriele Romualdi 521111
## Simone Chilosi 522155

using Base.Threads

function vertCongruenceAA_OPT(W)
	err, i, todelete, vclasses = 10^-6, 1, [], []
	verts = convert(Lar.Points, W')
	kdtree = NearestNeighbors.KDTree(verts)
	newverts = zeros(Int, size(verts,2))
	@threads for vi in 1:size(verts,2)
		if !(vi in todelete)
			nearvs = NearestNeighbors.inrange(kdtree, verts[:,vi], err)
			push!(vclasses,nearvs)
			newverts[nearvs] .= i
			nearvs = setdiff(nearvs, vi)
			todelete = union(todelete, nearvs)
			i += 1
		end
	end
	V = zeros(3,length(vclasses))
	@sync for (k,class) in enumerate(vclasses)
			@async V[:,k] = sum(W[class,:],dims=1)/length(class)
	end
	return V, vclasses
end


function cellCongruenceAA_OPT(Delta,inclasses)
	cellarray = Lar.cop2lar(Delta)
	new_e = Array{Int64,1}(undef,size(Delta,2))
	@sync for (k,class) in enumerate(inclasses)
		@async for e in class
			new_e[e] = k
		end
	end
  cells = [map(e->new_e[e], face) for face in cellarray]
  outclasses = DefaultOrderedDict{Array{Int64,1},Array{Int64,1}}([])
  @sync for (k,face) in enumerate(cells)
    @async begin
        if outclasses[face] == []
            outclasses[face] = [k]
        else
            append!(outclasses[face],[k])
        end
    end
  end
	FEnew = sort(collect(keys(outclasses)))
  outclasses = sort(collect(values(outclasses)))
  return FEnew,outclasses
end


function chainCongruenceAA_OPT(W, T)
	V, vclasses = vertCongruenceAA_OPT(W)
	@async EV, eclasses = cellCongruenceAA_OPT(T[1],vclasses)
	@async FE, fclasses = cellCongruenceAA_OPT(T[2],eclasses)
	#@show size(V,2) - size(EV,1) + size(FE,1)
	@sync return V,EV,FE
end
