function pvcongruence(W)
	err, i, todelete, vclasses = 10^-6, 1, [], []
	verts = convert(Lar.Points, W')
	kdtree = NearestNeighbors.KDTree(verts)
	newverts = zeros(Int, size(verts,2))
	for vi in 1:size(verts,2)
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
	for (k,class) in enumerate(vclasses)
			V[:,k] = sum(W[class,:],dims=1)/length(class)
	end
	return V, vclasses
end


V, vclasses = vcongruence(W)

GL.VIEW([
	GL.GLAxis(GL.Point3d(-1,-1,-1),GL.Point3d(1,1,1))
  #GL.GLPol( V,[[1,2,3,4,5,6,7,8]], GL.COLORS[1])
	GL.GLPol( V,FV, GL.COLORS[1])
]);



function EVcongruence2(Delta_0,vclasses)
	Y = SparseVector[]
	for class in vclasses
		y = sparsevec(sum(Delta_0[:,class],dims=2))
		push!(Y,y)
	end
	copEV = hcat(Y...)


	function econgruence(copEV)
		eclasses = sort([(findnz(copEV[k,:])[1],k) for k=1:copEV.m])
		class = [eclasses[1]]
		classes = []
		for h=2:length(eclasses)
			if eclasses[h][1]!=class[end][1]
				push!(classes, class)
				class = []
			end
			push!(class, eclasses[h])
		end
		return classes
	end

	eclasses = [[idx for (edge,idx) in class] for class in econgruence(copEV)]
	lastclass = setdiff(1:Delta_0.m, cat(eclasses))
	push!(eclasses,lastclass)


	newedges = [eclass[1] for eclass in eclasses]
	newEV = hcat([copEV[k,:] for k=1:copEV.m if k in newedges]...)

	return newEV,eclasses
end
