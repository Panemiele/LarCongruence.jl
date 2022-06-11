## [CPD22-7a] COMPONENTI DEL GRUPPO
## Gabriele Romualdi 521111
## Simone Chilosi 522155

using Base.Threads;

function vertCongruenceOptimized(V::Lar.Array{Float64,2}; ϵ=1e-6)
	Vcls    = []
	let visited = [],  kdtree = NearestNeighbors.KDTree(V)
		@sync for vidx = 1 : size(V, 2)
            @async begin
                if !(vidx in visited)
                    nearvs = NearestNeighbors.inrange(kdtree, V[:, vidx], ϵ)
                    push!(Vcls, nearvs)
                    push!(visited, nearvs...)
                end
            end
		end
	end

	V = hcat([sum(V[:, cl], dims=2)/length(cl) for cl in Vcls]...)
	return V, Vcls
end