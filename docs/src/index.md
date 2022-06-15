Progetto **LAR Congruence** per il corso di **Calcolo Parallelo e Distribuito** svolto da:

| Nome| Matricola | E-mail | Profilo Github |
|:---|:---|:---|:---|
| Gabriele Romualdi|521111|gab.romualdi@stud.uniroma3.it| [https://github.com/Panemiele](https://github.com/Panemiele)|
| Simone Chilosi|522155|sim.chilosi@stud.uniroma3.it|[https://github.com/simochilo](https://github.com/simochilo)|

Link al repository GitHub: [https://github.com/Panemiele/LarCongruence.jl](https://github.com/Panemiele/LarCongruence.jl)

Link ai notebook:
  - `Array Of Arrays`: [https://github.com/Panemiele/LarCongruence.jl/examples/notebooks/[CPD22-7a]notebook_ArrayOfArrays.ipynb](https://github.com/Panemiele/LarCongruence.jl/examples/notebooks/[CPD22-7a]notebook_ArrayOfArrays.ipynb)
  - `GraphBLAS`: [https://github.com/Panemiele/LarCongruence.jl/examples/notebooks/[CPD22-7a]notebook_GraphBLAS.ipynb](https://github.com/Panemiele/LarCongruence.jl/examples/notebooks/[CPD22-7a]notebook_GraphBLAS.ipynb)
  - `Julia Native Sparse Matrix`: [https://github.com/Panemiele/LarCongruence.jl/examples/notebooks/[CPD22-7a]notebook_JuliaNativeSparseMatrix.ipynb](https://github.com/Panemiele/LarCongruence.jl/examples/notebooks/[CPD22-7a]notebook_JuliaNativeSparseMatrix.ipynb)

# 1 - LarCongruence.jl

`LarCongruence.jl` è una libreria [Julia](http://julialang.org) che fornisce strumenti per gestire congruenze locali di complessi di catene.

In particolare, dato un insieme di complessi di catene locali secondo gli standard
LinearAlgebraicRepresentation, questo modulo Julia calcola il singolo complesso globale corrispondente usando la ``\epsilon``-congruenza delle celle,
risolvendo topologicamente le inesattezze numeriche dell'aritmetica dei floating-point.

## Dipendenze

`LarCongruence.jl` utilizza alcune dipendenze, di seguito elencate:
 - [```DataStructures.jl```](https://github.com/JuliaCollections/DataStructures.jl)
 - [```GraphBLASInterface.jl```](https://github.com/abhinavmehndiratta/GraphBLASInterface.jl)
 - [```LinearAlgebraicRepresentation```](https://github.com/cvdlab/LinearAlgebraicRepresentation.jl)
 - [```NearestNeighbors.jl```](https://github.com/KristofferC/NearestNeighbors.jl)
 - [```SparseArrays.jl```](https://github.com/JuliaSparse/SparseArrays.jl)
 - [```SparseMM.jl```](https://github.com/cvdlab/SparseMM)
 - [```SuiteSparseGraphBLAS```](https://github.com/abhinavmehndiratta/SuiteSparseGraphBLAS.jl)

In aggiunta, [CVD-Lab](https://github.com/cvdlab) provides also
[ViewerGL](https://github.com/cvdlab/ViewerGL.jl), un OpenGL
3D viewer interattivo utilizzato negli esempi di questo modulo.

## Installazione

```julia
pkg> add https://github.com/Panemiele/LarCongruence.jl
```
