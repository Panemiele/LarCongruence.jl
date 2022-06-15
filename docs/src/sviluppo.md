In questa sezione, verranno discussi gli step seguiti durante l'avanzamento del progetto.

# Studio preliminare
In questa prima fase, gli sforzi sono stati concentrati sullo studio della teoria di base legata intrinsecamente al progetto:
* Accezioni e nomenclature matematiche (es: monoidi, semirings, matrici sparse, ...)
* Studio delle strutture algebriche (es: celle, catene, cocatene, ...)
* Studio del linguaggio Julia (sintassi, funzioni, macro, ...)
* Concetti base sul funzionamento di GraphBLAS e funzioni Julia (SuiteSparseGraphBLAS e GraphBLASInterface)
* Concetti base sul funzionamento di Local Congruence (Sparse Matrix, Array of Arrays e GraphBLAS stesso)
Inoltre, ci si è concentrati sulla realizzazione di un buon grafo delle dipendenze.

# Studio esecutivo
Il secondo step racchiude il modo in cui sono stati modificate le funzioni dei progetti cea-SM.jl, cea-GB.jl e cea-AA.jl, in modo tale da introdurre un buon grado di parallelismo e migliorare le prestazioni. Per fare ciò, sono state utilizzate le funzioni e le macro offerte da Julia che permettono di operare in modo parallelo tramite semplice annotazioni; i concetti chiave utilizzati sono:
* Threads
* Tasks
* Simd

## Modifiche effettuate
Ci si è concentrati sul migliorare la funzione "CellCongruence()" in tutte e tre le implementazioni (SS, AA, e GB): questa funzione ha l’obiettivo di eseguire la congruenza di celle e complessi di celle tra la geometria e la topologia passate in input. Poiché questo processo può essere eseguito in modo indipendente faccia per faccia, risulta opportuno parallelizzare la funzione tramite le macro fornite da Julia. A tale scopo, sono state attuate le seguenti modifiche:
* Sparse Matrix: 
    * la funzione vertCongruence (dal file verticesCongruence.jl) `e stata modifica in vertCongruen-
ceOptimized (nel file verticesCongruence-optimized.jl), aggiungendo l’utilizzo dei Tasks;
    * la funzione chainCongruenceSM OPT(...) è stata migliorata sfruttando i Tasks;
    * la funzione cellCongruenceSM OPT(...) è stata migliorata sfruttando i Tasks e SIMD.
* GraphBLAS: Per quanto riguarda GraphBLAS, è stato scelto di implementare una sola modifica, per non penalizzare
le performance: sono stati usati i Thread (in particolare 6) per eseguire la funzione cellCongruen-
ce OPT(...)
* Array of Arrays:
    * 



# Studio definitivo

## Riferimenti
Per consultare il codice, si rimanda al link del repository [GitHub](https://github.com/Panemiele/LarCongruence.jl), mentre per uno studio approfondito delle varie macro di Julia sopracitate, verranno elencati i vari link della documentazione:
* [Threads](https://docs.julialang.org/en/v1/manual/multi-threading/)
* [Tasks](https://docs.julialang.org/en/v1/manual/asynchronous-programming/)
* [SIMD](https://docs.julialang.org/en/v1/manual/performance-tips/)