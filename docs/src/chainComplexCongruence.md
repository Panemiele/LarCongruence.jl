# 4.2 - Chain Complex Congruence

Once the **Geometry** of the model has been arranged,
**Topology** must be updated as well.
As from `Lar` standards Topology is managed as Cochain Operators

`vertCongruence()` method provides both the new Geometry set and
the map that maps old vertices in newly born ones.
This is what we refer to `lower_order_classes` w.r.t. ``[\Delta_0]``,
the 1-Cochain operator matrix (in short `lo_cls`). This map, built as a Julia
`Array{Array{Int,1},1}`, is needed when building ``[\delta_0]``.
In particular, the `cellCongruence()` for ``[\Delta_k]`` produces both
``[\delta_k]`` and a map for cell classes that behaves like the one produced by
`vertCongruence()`: this way the same method can be employed iterativelly
over all the Cochain Operators, from the lowest degree up to the hihest.

Under general setting, given a Cochain operator ``[\Delta_k] : C_{k-1} \to C_k``
and a `lo_cls` map steps are needed:
* ``C_{k-1}`` cells are identified with their new representative index according the mapping `lo_cls`.
* ``C_k`` cells are purged from duplicates cells ``C_{k-1}``. If this occurres then the corresponding cell topology has changed and this follows from low resolution problems.
  * If a cell results in having less than ``k + 2`` elements, then it is discarded since it has been assimilated in lower order cells.
  * Due to low resolution problems topological gift wrapping (TGW) algorithm may be required on ``\{C_k\}_{k>1}`` since new cell may have been formed.
* ``C_k`` cells are compared and duplicates are removed.
* A map `ho_cls` (we refer to it as _higher order_ in contrast with `lo_cls`) between ``C_k`` of ``[\Delta_k]`` and the survivors from previous step is built. 

In the original use case of the `Arrangment` pipeline the Cochain Operator
Matrices ``[\Delta_k]`` providden as input have values accumulated on the
diagonal as shown in Figure 1. In this case string conditions are likelly to
be required: _e.g._ only points from diffenet complexes are possibly merged.

![](./images/nestedMatrix.png)
> **Figure 1:** Doubly nested structure of sparse block-matrices ``[\Delta_k] : C_{k-1} \to C_k``. Here light gray portions identify the originally arranged complexes that are merged toghether. Dark grey portions are instead the cells within the same complex and are the only portions where values are stored.

Three implementation are provided in this package.

## Array of Array based

```@docs
LC.cellCongruenceAA
```

## Native Julia Sparse Matrices


Docstring follows

```@docs
LC.cellCongruenceSM
```

Even if slower than the previous method, employing Julia `SparseArrays` module
cames with the benefit of keeping signed representation updated.

The `cellCongruence()` method requires an additional input in the name
of `lo_sign::Array{Array{Int8,1},1}` that is complementary to `lo_cls`
as it holds the sign of the lower order cells. Likewise, an `ho_sign`
is provided as output.
In fact, when multiple cells are identified as one, then
the new cell is ordered as in Lar standard; therefore, if the old
cells were discordelly oriented, then the sign must be changed in the higher
order Cochain coherently.

Do note that points do not come with a sign so when ``[\Delta_0]`` is built,
`lo_sign` is not needed and it is therefore set to one for every vertex:
```julia
lo_sign = [ones(Int8, length(cl)) for cl in lo_cls]
```


## `GraphBlas` based


```@docs
LC.cellCongruenceGB
```

## Time and Space comparisons