## [CPD22-7a] COMPONENTI DEL GRUPPO
## Gabriele Romualdi 521111
## Simone Chilosi 522155

using Base.Threads;

"""
	vertCongruenceOptimized(V)

Valuta ed esegue la congruenza di vertici per punti 3D ``V ∈ ℳ(3,n)``.

La funzione determina i punti di `V` più vicini di `ϵ` e costruisce un nuovo insieme
di vertici costituito dal rappresentativo per ciascun cluster di punti. Per fare ciò
si utilizza l'algoritmo KDTree fornito dal package NearestNeighbors.

Il metodo restituisce:
 - il nuovo insieme di vertici
 - una mappa che, per ogni nuovo vertice, identifica i vecchi vertici nell'insieme di partenza

# Argomenti
- 'V::Lar.Array{Float64,2}'
- 'ϵ=1e-6'

# Return
- `(V, Vcls)::Tuple{Lar.Points, Array{Array{Int,1},1}}`
"""
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