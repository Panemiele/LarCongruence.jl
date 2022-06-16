## [CPD22-7a] COMPONENTI DEL GRUPPO
## Gabriele Romualdi 521111
## Simone Chilosi 522155

using Base.Threads

"""
	vertCongruenceAA_OPT(W)

Valuta ed esegue la congruenza di vertici per punti 3D ``W ∈ ℳ(3,n)``.

La funzione determina i punti di `W` più vicini di `err` (definito all'interno della funzione,
valore pari a 10^-6) e costruisce un nuovo insieme di vertici costituito dal rappresentativo 
per ciascun cluster di punti. Per fare ciò si utilizza l'algoritmo KDTree fornito dal package 
NearestNeighbors.

Il metodo restituisce:
 - il nuovo insieme di vertici
 - una mappa che, per ogni nuovo vertice, identifica i vecchi vertici nell'insieme di partenza

# Argomenti
- 'V::Lar.Array{Float64,2}'

# Return
(V, Vlasses)::Tuple{Lar.Points, Array{Array{Int,1},1}}
"""
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

"""
cellCongruenceAA_OPT(Delta, inclasses)

Valuta la congruenza tra celle per una parte di topologia `Delta` utilizzando le classi `inclasses`,
cioè la mappa che identifica per ciascun nuovo vertice calcolato i vecchi vertici di partenza, 
oppure la mappa che identifica per ciascun nuovo bordo calcolato i vecchi bordi di partenza.

La funzione restituisce:
	- la matrice che rappresenta i nuovi bordi calcolati e la mappa che li lega ai bordi di partenza 
	  se in input viene passato un insieme di vertici e la mappa che li lega ai vertici di partenza.
	- la matrice che rappresenta le nuove facce calcolate e la mappa che le lega alle facce di partenza
	  se in input viene passato un insieme di bordi e la mappa che li lega ai bordi di partenza.


# Argomenti
- `Delta::SparseMatrixCSC{Int8, Int64}`
- `inclasses::Vector{Any}`


# Return
(FEnew, outclasses)::Tuple{ Vector{Vector{Int64}},  Vector{Vector{Int64}}}
"""
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

"""
chainCongruenceAA_OPT(W, T)
Calcola la congruenza della geometria `W` e coerentemente trasforma la topologia `T`
La funzione restituisce tra matrici di incidenza/adiacenza:
	- V (il nuovo insieme di vertici calcolato con vertCongruenceAA_OPT)
	- EV (matrice di adiacenza bordi/vertici, calcolata con cellCongruence_OPT utilizzando vclasses)
	- FE (matrice di adiacenza facce/bordi, calcolata con cellCongruence_OPT utilizzando eclasses)
	
# Argomenti
- `W::Lar.Points`
- `T::Vector{SparseMatrixCSC{Int8, Int64}}`

# Return
- `(V, EV, FE)::Tuple{Lar.Points, Vector{Vector{Int64}}, Vector{Vector{Int64}}}`

"""
function chainCongruenceAA_OPT(W, T)
	V, vclasses = vertCongruenceAA_OPT(W)
	@async EV, eclasses = cellCongruenceAA_OPT(T[1],vclasses)
	@async FE, fclasses = cellCongruenceAA_OPT(T[2],eclasses)
	#@show size(V,2) - size(EV,1) + size(FE,1)
	@sync return V,EV,FE
end
