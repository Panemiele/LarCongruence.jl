# 3 - Introduction to GraphBLAS Framework
[GraphBLAS](http://graphblas.org/i) is an API that defines a set of sparse matrix operation based on an algebra of semirings and designed to do computation on graphs.

Local congruence of Chain Complexes extends GraphBLAS domain from graphs to cellular complexes.

An interface to SuiteSparse:GraphBLAS C library for [Julia](https://julialang.org/) is provided by two library: [```SuiteSparseGraphBLAS.jl```](https://github.com/abhinavmehndiratta/SuiteSparseGraphBLAS.jl) and [```GraphBLASInterface.jl```](https://github.com/abhinavmehndiratta/GraphBLASInterface.jl).

Each GraphBLAS function operates on a [semiring](https://en.wikipedia.org/wiki/Semiring) ``S = \langle D_{out}, D_{in1}, D_{in2}, \bigoplus, \bigotimes, 0 \rangle``, defined by three domains ``D_{out}, D_{in1}, D_{in2}``, two binary operators, a commutative and an associative additive operation ``\bigoplus : D_{out} \times D_{out} \rightarrow D_{out}`` and a multiplicative operation ``\bigotimes : D_{in1} \times D_{in2} \rightarrow D_{out}``, and an identity element ``0 \in D_{out}``, that satisfies the following two conditions in their respective domains:
1. Additive identity: ``a \bigoplus 0 = a``
2. Multiplicative annihilation: ``a \bigotimes 0 = 0``

A single domain ``D``, together with an associative operation `` \bigodot : D \times D \rightarrow D`` and an identity element ``0 \in D`` define a GraphBLAS monoid.

It is possible to create a monoid with a binary operator and an identity value, and a semiring with a monoid and a binary operator, respectively with ```GrB_Monoid_new(monoid, binary_op, identity)``` and ```GrB_Semiring_new(semiring, monoid, binary_op)```.

With monoid and semirings, in GraphBLAS you can override the normal plus and times operators in matrices multiplications, performed with ``GrB_mxm``, in order to define complex algorithm in the language of linear algebra.
