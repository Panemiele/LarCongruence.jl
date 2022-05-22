"""
	vertCongruence(V::Lar.Array{Float64,2}; ϵ=1e-6)::Tuple{Lar.Points, Array{Array{Int,1},1}}

Evaluates the Vertex Congruence for 3D-points ``V ∈ ℳ(3,n)``.

The function determines the points of `V` closer than `ϵ` and
builds a new Vertex Set made of the representative of each point cluster.

The method returns:
 - the new Vertex Set
 - a map that, for every new vertex, identifies the old vertices it is made of
"""
function vertCongruence(V::Matrix{Float64}; ϵ=1e-6)
	Vcls    = []
	let visited = [],  kdtree = NearestNeighbors.KDTree(V)
		for vidx = 1 : size(V, 2)  if !(vidx in visited)
			nearvs = NearestNeighbors.inrange(kdtree, V[:, vidx], ϵ)
			push!(Vcls, nearvs)
			push!(visited, nearvs...)
		end  end
	end

	V = hcat([sum(V[:, cl], dims=2)/length(cl) for cl in Vcls]...)
	return V, Vcls
end