## [CPD22-7a] COMPONENTI DEL GRUPPO
## Gabriele Romualdi 521111
## Simone Chilosi 522155

using Base.Threads;
LC = LarCongruence

"""
cellCongruenceSM_OPT(cop, lo_cls, lo_sign)

Valuta la congruenza tra celle per una cocatena `cop` utilizzando le classi `lo_cls`,
cioè la mappa che identifica per ciascun nuovo vertice calcolato identifica i vecchi vertici di partenza.

La funzione determina il nuovo operatore di cocatena costruito a partire da `cop`
dove viene eseguito il merge delle celle di ordine inferiore secondo la mappa `lo_cls`.
`lo_sign` specifica se una cella debba essere considerata nel verso opposto.

Se il parametro opzionale `imp` vale `true`, allora le imprecizioni vengono tenute in considerazione
nel senso che le celle di ordine inferiore potrebbero collidere.
Il parametro `d` rappresenta, quindi l'ordine della cella (corrisponde anche al numero minimo di celle
 di ordine inferiore di cui la cella corrente deve essere costituita).

# Argomenti
- `cop::Lar.ChainOp`
- `lo_cls::Array{Array{Int,1},1}`
- `lo_sign::Array{Array{Int8,1},1}`
- `imp = false`
- `d = 0`


# Return
(nrows, ho_cls, ho_sign)::Tuple{ Lar.ChainOp,  Array{Array{Int,1},1},  Array{Array{Int8,1},1} }
"""
function cellCongruenceSM_OPT(cop, lo_cls, lo_sign; imp = false, d = 0)

	# Collide columns
	copCols = []
    @simd for i = 1 : length(lo_cls)
            col = sum([
                cop[:, lo_cls[i][j]] .* lo_sign[i][j]
                for j = 1 : length(lo_cls[i])
            ])
            push!(copCols, col)
    end

	# Retrieve Matrix Form and extract rows
	cop = hcat(copCols...)
	rows = [cop[row, :] for row = 1 : cop.m]

	# Adjustinfg signs such that the first value always is `-1`
	sign = ones(Int8, cop.m)
	@sync for row = 1 : cop.m
        if rows[row].nzval[1] > 0
            @async begin
                rows[row] = -rows[row]
                sign[row] = -1
            end 
        end
    end

	# Sort rows in order to collide them quickly
	rows_ord = sortperm(rows)
	nrows = unique(rows[rows_ord])
	ho_cls = [Array{Int,1}() for i = 1 : length(nrows)]
	nidx = 1

	# Collide cells with same structure
	@simd for cidx = 1 : cop.m
        if rows[rows_ord[cidx]] != nrows[nidx]  
            nidx = nidx + 1;
        end
        push!(ho_cls[nidx], rows_ord[cidx])
	end

	# Reshaping Sign and Cochain
    ho_sign = [[sign[el] for el in cell] for cell in ho_cls]
#	cop = convert(Lar.ChainOp, hcat(nrows...)')

	return hcat(nrows...)', ho_cls, ho_sign
end

"""
chainCongruenceSM_OPT(G, T)
Calcola la congruenza della geometria `G` e coerentemente trasforma la topologia `T`

# Argomenti
- `G::Lar.Points`
- `T::Array{Lar.ChainOp}`
- `imp=false`
- `ϵ=1e-6`

# Return
- `(G, Tn)::Tuple{Lar.Points, TnArray{Lar.ChainOp}}`

"""
function chainCongruenceSM_OPT(G, T; imp=false, ϵ=1e-6)
	# Perform the Geometry Congruence
	G, cls = vertCongruenceOptimized(G; ϵ=ϵ)
	# Build default sign
	sign = [ones(Int8, length(cl)) for cl in cls]
	# Update the Topology coherently
	Tn = Array{Lar.ChainOp, 1}(undef, length(T))
    @sync for d = 1 : length(T)
        @async Tn[d], cls, sign = cellCongruenceSM_OPT(T[d], cls, sign; imp=imp, d=d)
    end
	# Euler Characteristic
	# @show size(G,2) - size(T[1],1) + size(T[2],1)
	return G, Tn
end
