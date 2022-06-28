# Esempi

In questa sezione, verranno mostrati diversi esempi per mostrare la correttezza degli input e degli output:
* Alcuni di questi esempi sono di dimensioni contenute, per introdurre il lettore in modo graduale;
* Altri esempi invece hanno dimensioni sufficientemente grandi da "mettere in crisi" un calcolatore con specifiche medie;
* Altri ancora sono più complessi e, oltre a mostrare la correttezza dell'output, mostrano l'effetto della funzione "chainCongruence()", la quale riduce le dimensioni delle matrici EV ed FV (la dimensione si riduce perché vengono rimossi vertici, facce e spigoli duplicati);
In questi esempi, sono mostrate anche le differenze tra una versione non ottimizzata di "chainCongruence()" ed una ottimizzata.
E' stato usato in modo massiccio ViewerGL, così da poter verificare in modo visuale la correttezza dell'output generato.

!!! note "Nota"
    La funzione **chainCongruence()** utilizzata in questi esempi fa riferimento all'implementazione di ***Array of Arrays***; verranno mostrati i confronti tra le varie implementazioni nella prossima sezione.

!!! warning "Limiti di Space Arrangement"
    La funzione **space_arrangement()** usata negli esempi potrebbe impiegare davvero tanto tempo per input molto grandi e, probabilmente, entrerà in loop. Si consiglia, pertanto, di effettuare dei test sulla macchina utilizzata al fine di studiarne i range possibili.![Edges-Vertices](assets/SpaceArrangementTooLong.png)

## Global Set up
Prima di lanciare gli esempi, verrà preparato l'ambiente adatto: si importano le librerie necessarie al corretto funzionamento, quali: LinearAlgebraicRepresentation, LarCongruence, ViewerGL.
Successivamente, vengono definite delle versioni migliorate delle funzioni **chainCongruence()** e **coboundary_1()**: le modifiche apportate fanno si che entrambe le funzioni si comportino in modo adeguato su input di grandi dimenzioni.<br><br>Dopo il set up, si è pronti a lanciare gli esempi in tutta libertà.
```julia
using BenchmarkTools
using ViewerGL, LinearAlgebra
using LinearAlgebraicRepresentation
using NearestNeighbors, DataStructures, SparseArrays
using StatsAPI
using SparseMM
using LarCongruence
using Images
using Colors
using Plots
using Base.Threads
using SparseArrays
using DataStructures
using NearestNeighbors
using LinearAlgebra
nthreads()
```
```julia
Lar= LinearAlgebraicRepresentation;
L = Lar;
LC = LarCongruence;
using ViewerGL;
GL = ViewerGL;
```
## Chain Congruence - Versioni normale e modificata
Prima di proseguire con gli esempi, verranno definite le funzioni utilizzate per calcolare la congruenza; in particolare, vengono proposte due versioni:
* **chainCongruenceAA()**, versione normale della funzione, basata su Array of Arrays;
* **chainCongruenceAA_OPT()**, versione che sfrutta i tasks.<br>
La funzione chainCongruenceAA() è stata modificata aggiungendo a **cellCongruenceAA_OPT()** l'utilizzo dei tasks, precisamente nel primo for: quì vengono scorse le classi di vertices (se viene chiamata cellCongruenceAA_OPT(T\[1\],vclasses) ) o di edges (se invece viene chiamata cellCongruenceAA(T\[2\],eclasses); la cardinalità di vclasses, per esempio, è pari al numero di vertici della geometria, perciò più grande questa è grande, maggiore è la necessità di rendere asincrona questa porzione di codice. 


## Example 1 - two intersecting cuboids grid
### Grid size: 3x3x3<br>Cells number: 27x2 = 54
Questo piccolo esempio è stato proposto per mostrare, innanzitutto, la corretta creazione delle griglie di input e la corretta visualizzazione dell'output. L'approccio seguito in questo esempio (la struttura dell'esempio stesso e l'utilizzo di ViewerGL) verrà riproposto anche nei successivi.<br>
Le due griglie, che differiscono leggermente di posizione e rotazione, sono intersecate fra loro e possiedono, in totale, un numero pari a 54 celle (27 per griglia). Data la traslazione e la rotazione di cui sopra, non è ancora possibile, in questo esempio, mostrare il comportamento della funzione **chainCongruence()**; tuttavia, rimane un buon esempio iniziale per comprendere il dominio applicativo.
![Edges-Vertices](assets/3x3x3%20CuboidGrid/TwoSimpleCuboidsGridEV.png)
![Facets-Vertices](assets/3x3x3%20CuboidGrid/TwoSimpleCuboidsGridFV.png)
Per completare l'esempio e mostrare il pattern seguito nei vari esempi, vengono mostrati ulteriori dettagli grafici; questi permettono, in ordine, di mostrare:
* vertici e facce della geometria numerati:
![Numbering](assets/3x3x3%20CuboidGrid/TwoSimpleCuboidsGridNumbering.png)
* le facce della geometria:
![Explode Facets](assets/3x3x3%20CuboidGrid/TwoSimpleCuboidsGridFacets.png)
* gli spigoli della geometria:
![Explode Edges](assets/3x3x3%20CuboidGrid/TwoSimpleCuboidsGridEdges.png)
* la decomposizione della geometria:
![Decomposition](assets/3x3x3%20CuboidGrid/TwoSimpleCuboidsGridComp.png)
## Example 2 - two adjacent cubes on faces
### Cubes number: 2
Quest'altro piccolo esempio permette di osservare il comportamento della funzione **chainCongruence()** in modo molto semplice.
* vengono creati due cubi adiacenti su una delle loro facce (verrà aggiunta una distanza di 0.0000001 tra un cubo ed un altro per evitare che la funzione **cuboid()** risolva la congruenza al posto della funzione **chainCongruence()**);
* tali cubi sono creati in modo separato, perciò **essi avranno i vertici e la faccia** su cui risultano adiacenti **duplicati**;
* godendo di queste caratteristiche, alla geometria può essere applicata la funzione **chainCongruence()** che fa si che i vertici e le facce duplicate vengano rimosse, mettendo "a fattor comune" vertici e facce su cui i cubi risultano adiacenti
Essendo due cubi, ci si aspetta di passare, per quanto riguarda il **numero di vertici distinti**, **da 16 a 12** mentre per le **facce distinte** ci si aspetta di passare **da 12** (6 per cubo) **a 8**: questo perché 4 vertici + 1 faccia sono in comune tra i due cubi e, perciò, la funzione utilizzata rimuoverà tali copie.
![Edges-Vertices](assets/adjacentOnFace/EV.png)
![Facets-Vertices](assets/adjacentOnFace/FV.png)

### Chain Congruence application
**Verrà ora dimostrato che la dimensione di EV ottenuto dopo la congruenza è minore rispetto a quello iniziale.**
Questo è dovuto al fatto che 4 vertici ed una faccia risultano duplicati e la funziona "chainCongruence()" li ha eliminati (come volevasi dimostrare: **EV - EV_B = 24 - 20 = 4** vertici doppioni eliminati). La figura risultante, come si vede dall'immagine sottostante, è esattamente identica a quella iniziale, nonostante l'eliminazione dei vertici duplicati.
![After congruence](assets/adjacentOnFace/AfterCongruence.png)
Anche in questo caso, vengono mostrati ulteriori dettagli grafici:
![Numbering](assets/adjacentOnFace/Numbering.png)
![Explode Facets](assets/adjacentOnFace/Facets.png)
![Explode Edges](assets/adjacentOnFace/Edges.png)
![Decomposition](assets/adjacentOnFace/Comp.png)

# Example 3 - two adjacent cubes on the edges
### Cubes number: 2
Un altro esempio di dimensioni contenute; anche quì si osserva il comportamento della funzione **chainCongruence()**.
* vengono creati due cubi adiacenti su uno dei loro spigoli (verrà aggiunta una distanza di 0.0000001 tra un cubo ed un altro per evitare che la funzione **cuboid()** risolva la congruenza al posto della funzione **chainCongruence()**);
* tali cubi sono creati in modo separato, perciò **essi avranno lo spigolo** su cui risultano adiacenti **duplicato**;
* godendo di queste caratteristiche, alla geometria può essere applicata la funzione **chainCongruence()** che fa si che lo spigolo duplicato venga rimosso, mettendolo "a fattor comune".
Essendo due cubi, ci si aspetta di passare, per quanto riguarda il **numero di spigoli**, **da 24 a 23**: questo perché lo spigolo è in comune tra i due cubi e, perciò, la funzione utilizzata rimuoverà una delle due copie.
![Edges-Vertices](assets/adjacentOnEdge//EV.png)
![Facets-Vertices](assets/adjacentOnEdge/FV.png)

### Chain Congruence application
**Verrà ora dimostrato che la dimensione di EV ottenuto dopo la congruenza è minore rispetto a quello iniziale.**
Questo è dovuto al fatto che uno spigolo risulta duplicato e la funzione "chainCongruence()" lo ha eliminato (come volevasi dimostrare: **EV - EV_B = 24 - 23 = 1** spigolo doppione eliminato). La figura risultante, come si vede dall'immagine sottostante, è esattamente identica a quella iniziale, nonostante l'eliminazione dello spigolo duplicato.
![After congruence](assets/adjacentOnEdge/AfterCongruence.png)
Come per gli altri esempi, vengono mostrati ulteriori dettagli grafici:
![Numbering](assets/adjacentOnEdge/Numbering.png)
![Explode Facets](assets/adjacentOnEdge/Facets.png)
![Explode Edges](assets/adjacentOnEdge/Edges.png)
![Decomposition](assets/adjacentOnEdge/Comp.png)


# Example 4 - two near cubes 
### Cubes number: 2
Quest'ultimo esempio di piccole dimensioni viene proposto per capire i limiti di applicazione della funzione **chainCongruence()**.
* vengono creati due cubi:
    * Lo spigolo di uno dei due giace su una delle facce dell'altro
* tali cubi sono creati in modo separato, perciò essi saranno composti da vertici, facce e spigoli **distinti**;
* godendo di queste caratteristiche, alla geometria può essere applicata la funzione **chainCongruence()**, **MA essa non avrà alcun effetto**: infatti, dato che non ci sono vertici, facce o spigoli in comune tra i due cubi, non esistono duplicati di essi, quindi la funzione non rimuoverà nulla.
![Edges-Vertices](assets/nearCube/EV.png)
![Facets-Vertices](assets/nearCube/FV.png)

### Chain Congruence application
**Verrà ora dimostrato che la dimensione di EV ottenuto dopo la congruenza è uguale a quella iniziale.**
Questo è dovuto al fatto che non ci sono vertici, facce o spigoli duplicati e quindi la funzione "chainCongruence()" non ha modificato nulla. Nonostante ciò, la figura risultante è la stessa.
![After congruence](assets/nearCube/AfterCongruence.png)
Come per gli altri esempi, vengono mostrati ulteriori dettagli grafici:
![Numbering](assets/nearCube/Numbering.png)
![Explode Facets](assets/nearCube/Facets.png)
![Explode Edges](assets/nearCube/Edges.png)
![Decomposition](assets/nearCube/Comp.png)

# Example 5 - Grid inside another grid
### Small Grid: 3x3x3<br>Big grid: 5x5x5<br>Cells number: 27 + 125 = 134
Riprendendo l'esempio precedente sulle griglie (il **numero 1**), ne verranno ora mostrate due di diverse dimensioni, con la più grande sovrapposta alla prima (le due griglie sono perfettamente congruenti sulle celle della più piccola tra le due).
L'obiettivo di questo esempio è mostrare come, applicando ***chainCongruence()***, sia possibile ridurre notevolmente il numero di vertici, facce e spigoli inizialmente creati, eliminando i doppioni; questa azione è necessaria perché le celle della griglia più piccola sono duplicate (la griglia più grande contiene celle nelle stesse identiche posizioni della più piccola, quindi vertici, spigoli e facce sono duplicate)
![Edges-Vertices](assets/littleTwoGrids/EV.png)
![Facets-Vertices](assets/littleTwoGrids/FV.png)

### Chain Congruence application
**Verrà ora dimostrato che la dimensione di EV ottenuto dopo la congruenza è minore rispetto a quello iniziale.**
Questo è dovuto al fatto che molti vertici risultano duplicati e la funziona "chainCongruence()" li ha eliminati (in particolare: **EV_A - EV_B = 684 - 540 = 144** vertici doppioni eliminati). La figura risultante, come si vede dall'immagine sottostante, è esattamente identica a quella iniziale, nonostante l'eliminazione dei vertici duplicati.
![After congruence](assets/littleTwoGrids/AfterCongruence.png)
Come per gli altri esempi, vengono mostrati ulteriori dettagli grafici:
![Numbering](assets/littleTwoGrids/Numbering.png)
![Explode Facets](assets/littleTwoGrids/Facets.png)
![Explode Edges](assets/littleTwoGrids/Edges.png)
![Decomposition](assets/littleTwoGrids/Comp.png)

# Example 6 - Grid inside another grid (BIG)
### Small Grid: 10x10x10<br>Big grid: 15x15x15<br>Cells number: 1000 + 3375  = 4375
Viene replicato l'esempio precedente, ma con dimensioni delle griglie decisamente più grandi (4375 celle contro le 134 dell'esempio precedente). L'obiettivo è quello di spingere il calcolatore ad effettuare calcoli di grande portata, mettendolo in difficoltà. Anche quì, verrà dimostrata la correttezza dell'output, sia della funzione **chainCongruence()**, sia delle funzioni per la presentazione grafica di ViewerGL.
![Edges-Vertices](assets/bigTwoGrids/EV.png)
![Facets-Vertices](assets/bigTwoGrids/FV.png)
### Chain Congruence application
**Verrà ora dimostrato che la dimensione di EV ottenuto dopo la congruenza è minore rispetto a quello iniziale.**
Questo è dovuto al fatto che molti spigoli risultano duplicati e la funziona "chainCongruence()" li ha eliminati (in particolare: **EV_A - EV_B = 15150 - 11520 = 3630** vertici doppioni eliminati). Come si può vedere, la griglia ottenuta è identica a quella di partenza, ma i vertici utilizzati per la sua creazione sono in numero minore.
![After congruence](assets/bigTwoGrids/AfterCongruence.png)
Come per gli altri esempi, vengono mostrati ulteriori dettagli grafici:
![Numbering](assets/bigTwoGrids/Numbering.png)
![Explode Facets](assets/bigTwoGrids/Facets.png)
![Explode Edges](assets/bigTwoGrids/Edges.png)
![Decomposition](assets/bigTwoGrids/Comp.png)


# Example 7 - 100x50 cuboids table
### Cells number: 100x50 = 5000
Questo esempio è stato pensato per testare le performance della funzione **chainCongruence()** nella sua versione normale e quella che sfrutta i tasks: ci si aspetterebbe un miglioramento nella seconda versione poiché questa presenta una piccola porzione di codice che lavora in modo asincrono; tale porzione, però, viene richiamata un numero di volte elevato, pari al numero di vertici nella geometria, ed essendo questa geometria molto vasta (il numero di vertici è alto), i benefici previsti dovrebbero essere alti (o quantomeno presenti). Il miglioramento sulla seconda versione, però, non si verifica: questo è dovuto alla semplicità della porzione di codice chiamata; seppur essa sia chiamata un numero di volte elevato, essendo molto semplice, **risulta più complesso utilizzare la programmazione asincrona** (e quindi i tasks) **piuttosto che lavorare in modo seriale**; perciò, la versione **normale** di chainCongruence() è preferibile.
![Edges-Vertices](assets/cuboids%20table//EV.png)
![Facets-Vertices](assets/cuboids%20table/FV.png)

### Confronto fra chainCongruence() normale e modificata
Come anticipato nella presentazione dell'esempio, ci si aspetterebbe un miglioramento, ma per via della semplicità della porzione di codice chiamata, risulta preferibile la versione normale. Tra l'altro, anche l'utilizzo di memoria è migliore nella versione normale: si passa da **60.38 MiB** della versione normale a **75.98 MiB** di quella modificata coi tasks; questo è dovuto alla porzione asincrona che richiede più risorse in parallelo.
![After congruence](assets/cuboids%20table/AfterCongruence.png)
* Versione normale:
![chainCongruence() Normale](assets/cuboids%20table/chainCongruenceNormal.png)
* Versione modificata:
![chainCongruence() Modificata](assets/cuboids%20table/chainCongruenceNormal.png)
<br><br>
Come per gli altri esempi, vengono mostrati ulteriori dettagli grafici:
![Numbering](assets/cuboids%20table/Numbering.png)
![Explode Facets](assets/cuboids%20table/Facets.png)
![Explode Edges](assets/cuboids%20table/Edges.png)
![Decomposition](assets/cuboids%20table/Comp.png)





# Confronto versioni "chainCongruence() tra le varie implementazioni"
Sono stati utilizzati tre esempi, tutti diversi tra loro in quanto a dimensioni dell'input, in modo da poter verificare i cambiamenti di comportamento delle funzioni al loro variare. Ci si aspetta dunque un miglioramento più evidente sugli esempi di dimensioni maggiore, questo perché eseguire operazioni complesse come quelle utilizzate per la programmazione asincrona e/o parallela, su input di piccole dimensioni, in modo controintuitivo, può penalizzare le prestazioni, cosa che non accade per input più grandi.
1. Esempio 1 - input 3x24
2. Esempio 2 - input 3x432
3. Esempio 3 - input 1192x3

La funzione testata e di cui si mostrano i confronti tra i diversi risultati nelle sezioni seguenti è **"chainCongruence()"**, nelle sue diverse versioni SM, GB, AA, eseguendo il confronto di ciascuna tra la versione originale del codice e quella ottimizzata introducento la parallelizzazione.

Per la valutazione delle prestazioni è stata utilizzata la macro julia **@benchmark**, presente all'interno del package BenchmarkTools.jl, la quale va a eseguire la funzione testata un certo numero di volte, restituendo tempo medio di esecuzione (espresso in millisecondi o microsecondi) e lo spazio medio allocato (espresso in Mebibyte o Kibibyte), nei grafici seguenti vengono mostrati i tempi medi di esecuzione.

# Julia Native Sparse Matrix
L'implementazione SM non ha mostrato grandi miglioramenti; come detto in precedenza le differenze sono più evidenti nel terzo esempio in quanto è quello che presenta input di dimensioni maggiori. In questo esempio infatti si ha un miglioramento sui tempi di esecuzione di circa il 6%.
![SM graph](assets/SMdarkunica.png) 
# GraphBLAS
L'implementazione GB è stata quella che ha risposto meglio alle modifiche, con evidenti miglioramenti in tutti gli esempi testati. Si nota infatti un netto miglioramento del 65% sui tempi di esecuzione, questo perché la funzione 'cellCongruence()' dell'implementazione GB si presta bene all'utilizzo dei threads.
![GB graph](assets/GBdarkunica.png) 
# Array of Arrays
Anche l'implementazione AA ha ottenuto buoni risultati dopo le modifiche, si nota un miglioramento di quasi il 20% sui tempi di esecuzione del primo esempio e uno di circa il 5% sul terzo.
![AA graph](assets/AAdarkunica.png)
