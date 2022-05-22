function __msc0(D::GrB_Matrix{T}, cols) where T
    r = GrB_Matrix_nrows(D)
    Ires, Xres = ZeroBasedIndex[], T[]
    vec = SparseMM.gbv_new(T, r)

    for j in cols
        GrB_Col_extract(vec, GrB_NULL, GrB_NULL, D, GrB_ALL, 0, ZeroBasedIndex(j.x-1), GrB_NULL)
        I, X = GrB_Vector_extractTuples(vec)
        append!(Ires, I)
        append!(Xres, X)
        GrB_Vector_clear(vec)
    end

    GrB_free(vec)
    return Ires, Xres

end

"""
    msc(D::GrB_Matrix{T}, v)

Sums D's columns which indexes are in V

# Arguments
 - `D`: a GraphBLAS matrix
 - `v`: list of indices
"""
function msc(D::GrB_Matrix{T}, v) where T
    r = GrB_Matrix_nrows(D)
    res = SparseMM.gbm_new(T, r, length(v))

    X = T[]
    J = ZeroBasedIndex[]
    I = ZeroBasedIndex[]

    for (i, c) in enumerate(v)
        _I, _X = __msc0(D, c)

        append!(I, _I)
        append!(X, _X)
        append!(J, fill(i-1, length(_X)))
    end

    GrB_Matrix_build(res, I, J, X, length(X), SparseMM.GrB_op("PLUS", T))

    return res

end

"""
    cellCongruence(Delta::GrB_Matrix{T}, vclasses)

Performs the Cell Congruence Enabling algorithm.

# Arguments
 - `Delta`: the Cochain operator
 - `classes`: list that indentifies old cells
"""
function cellCongruence(Delta::GrB_Matrix{T}, classes) where T
    copEV = msc(Delta, classes)

    function __congruence(copEV::GrB_Matrix{T}) where T
        ec = Dict{ZeroBasedIndex, Array{ZeroBasedIndex, 1}}()
        foreach(zip(GrB_Matrix_extractTuples(copEV)...)) do (i, j, _)
            push!(get!(ec, i, []), j)
        end
        c = Dict{Array{ZeroBasedIndex, 1}, Array{ZeroBasedIndex, 1}}()
        for (k, v) in ec
            push!(get!(c, v, []), k)
        end
        eclasses = [sort(v) for (k, v) in c]
        sort!(eclasses)
        return eclasses
    end
    eclasses = __congruence(copEV)
    newedges = first.(eclasses)
    
    res = SparseMM.gbm_new(T, GrB_Matrix_ncols(copEV), length(newedges))

    I, J, X = GrB_Matrix_extractTuples(copEV)
    _I, _J, _X = ZeroBasedIndex[], ZeroBasedIndex[], T[]

    for (i, j, x) in zip(I, J, X)
        if i in newedges
            push!(_J, findfirst(x -> x==i ,newedges)-1)
            push!(_I, j)
            push!(_X, x)
        end
    end

    GrB_Matrix_build(res, _I, _J, _X, length(_X), SparseMM.GrB_op("FIRST", T))
    return res, eclasses
end

"""
    chainCongruenceGB(G, Top)

Perform the Geometry ``G`` congruence and coherently reshape the Topology ``T`` (GraphBLAS implementation)
"""
function chainCongruenceGB(W, Top)
	V, cls = vertCongruence(W)
	cls = [[ZeroBasedIndex(c) for c in cl] for cl in cls]

	Topn = Array{GrB_Matrix{Int8}}(undef, length(Top))
	for i in eachindex(Topn)
		Topn[i], cls = cellCongruence(Top[i], cls)
	end

	return V, Topn
end
