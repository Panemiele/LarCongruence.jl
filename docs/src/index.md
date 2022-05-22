# 1 - LocalCongruence.jl

`LocalCongruence.jl` is a [Julia](http://julialang.org) library that provides
tools for managing local congruences of Chain Complexes.

The algorithms here presented are all official variation of those we proposed
in [Local congruence of chain complexes](https://arxiv.org/).

In particular, given a set of local chain complexes in
LinearAlgebraicRepresentation standars, this Julia Module compute a the single
corresponding global complex using ``\epsilon``-congruence of cells,
solving topologically the numerical inaccuracies of floating-point arithmetics.

The code is currently working as part of the `Lar.Arrangment` workflow. 

## Dependencies

`LocalCongruence.jl` has the following dependeces:
 - [```DataStructures.jl```](https://github.com/JuliaCollections/DataStructures.jl)
 - [```GraphBLASInterface.jl```](https://github.com/abhinavmehndiratta/GraphBLASInterface.jl)
 - [```LinearAlgebraicRepresentation```](https://github.com/cvdlab/LinearAlgebraicRepresentation.jl)
 - [```NearestNeighbors.jl```](https://github.com/KristofferC/NearestNeighbors.jl)
 - [```SparseArrays.jl```](https://github.com/JuliaLang/julia/tree/master/stdlib/SparseArrays)
 - [```SparseMM.jl```](https://github.com/cvdlab/SparseMM.jl)
 - [```SuiteSparseGraphBLAS```](https://github.com/abhinavmehndiratta/SuiteSparseGraphBLAS.jl)

In addition [CVD-Lab](https://github.com/cvdlab) provides also
[ViewerGL](https://github.com/cvdlab/ViewerGL.jl), an OpenGL
3D interactive viewer adopted in the examples of this module

## Installing

```julia
]add https://github.com/cvdlab/LocalCongruence.jl
```

## Docstrings conventions

 - **Bold** is used to point out theory concepts.
 - `Monospace` is used for everything code related.
