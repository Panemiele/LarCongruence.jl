# Vertices Congruence

```@docs
LarCongruence.vertCongruenceOptimized
```

```@Eval
err = 1e-8
V = [
    0.0  err  0.0 -err  0.0  0.0
    0.0  0.0  err  0.0 -err  0.0
]

LC.vertCongruenceOptimized(V[:, 1:5])

LC.vertCongruenceOptimized(V[:, 2:6])
```

# Variante per implementazione AA

```@docs
LarCongruence.vertCongruenceAA_OPT
```

