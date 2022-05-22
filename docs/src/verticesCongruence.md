# 4.1 - Vertices Congruence Algorithm

The Vertices congruence is the base of the
```Cell Congruence Enabling Algorithm```.

The merging procedure relies on the fact that points closed enought are
actually the same point.
This highlights the dichotomical relation between geometry and topology
within a model:
space location (**Geometry**) is needed in order to retrieve wich point to merge and consequently update the chain complexes (**Topology**).

The following interface allows close point recognition.
```@docs
LC.vertCongruence
```

The value ``\epsilon > 0`` actually serve as a discriminant for well
understending whether different points are actually the same.
As a side effect it also sets the resolution employed by the ```CCE``` algorithm
itself since, even if points within the resolution where different
at first glance, they arise to be the same after this procedure.

Do note that this powerful feature may actually cause loss in the topological
structure: low resolution processing decrease in fact further steps computation
complexity at the cost of a information loss.

In order to keep the complex as similar as possible to the input,
each points class is identified as the mean point of the set.

We employ a _KDTree_ structure in order to speedup the point scan;
this however means that if points are supplied in different order,
a different geometrical pattern may be generated
(even a diffent number of points)

```@Eval
err = 1e-8
V = [
    0.0  err  0.0 -err  0.0  0.0
    0.0  0.0  err  0.0 -err  0.0
]

LC.vertCongruence(V[:, 1:5])

LC.vertCongruence(V[:, 2:6])
```

![](./images/verticesCongruenceDiff.png)
> **Figure1** Output of the two `vertCongruence()` calls.


