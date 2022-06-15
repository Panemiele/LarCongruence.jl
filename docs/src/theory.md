In questa sezione, verranno introdotti i principali concetti matematici e tecnologici utilizzati all'interno del progetto LarCongruence.jl.
Verrà proposto, innanzitutto, un approccio teorico al 

## Matrici Sparse
In analisi numerica, una matrice sparsa è una matrice i cui valori sono quasi tutti uguali a zero. I pochi valori presenti sono distribuiti in modo casuale, cioè non si concentrano in determinate aree specifiche (Cluster).

## Semiring
Un Semiring è una struttura algebrica che generalizza l'aritmetica reale rimpiazzando (+,·) con l'operazione binaria (Op1, Op2).
Un Semiring, in GraphBLAS, viene definito come l'unione di un **monoide M** e un **operatore** binario moltiplicativo F};
* Il monoide è una struttura algebrica formata da un operatore binario **associativo** e commutativo di tipo additivo} e da **un dominio D** che deve contenere anche un elemento vuoto (simbolo dell'operatore: ⊕);
* L'operatore binario F è formato invece da **due domini di input** e **un dominio di output** (simbolo dell'operatore: ⊗).

# GraphBLAS
GraphBLAS è la libreria che offre funzioni per matrici sparse, la più comune quando si parla di calcolo parallelo e distribuito. Questa libreria offre metodi smart ed efficaci per memorizzare valori ed effettuare operazioni su di essi all'interno di matrici sparse. Si può scegliere di implementare GraphBLAS sia sulla CPU che su GPU (la cosa interessante delle GPU è che lo si può fare in parallelo). Si usano le matrici per rappresentare i grafi, in modo da poter utilizzare le operazioni dell'algebra lineare che sono molto veloci da eseguire: il prodotto fra matrici, per esempio, permette di ricavare informazioni sui percorsi possibili e nodi vicini. GraphBLAS utilizza oggetti matematici chiamati "Semirings" che permettono di implementare qualsiasi operatore matematico e definire così un nuovo modello di prodotto matriciale. Due esempi:
* Plus-times: tipico prodotto matriciale
* Tropical Semiring: usa i seguenti operatori:
    * interno: la somma
    * esterno: il valore minimo

# Lar Congruence
E' una libreria che ha l'obiettivo di eseguire la congruenza di celle e complessi di catene locali. Sono disponibili tre implementazioni di LarCongruence:
* Julia Native Sparse Matrix
* Array of Arrays
* GraphBLAS - estende il funzionamento di GraphBLAS, oltre che ai grafi, anche ai complessi cellulari.
    
Per calcolare la congruenza di complessi di catena locali si procede come segue: 
* Per ogni faccia, si costruisce il suo complesso di catene locale, cioè la partizione del piano bidimensionale (identificato con z=0) indotta dal bordo di quella faccia e da tutte le altre che la dividono. 
* Si rimette assieme per calcolare la congruenza: dall'insieme di complessi di catene locali ad ognuna delle facce dell'input, bisogna arrivare ad un unico complesso, "incollando" fra loro in modo coerente i vari complessi locali.
Si noti che l'operazione che può essere parallelizzata è la prima, questo perché viene eseguita in modo indipendente per ciascuna delle facce.

## SIMD
**Single Instruction, Multiple Data (SIMD)** è un metodo per parallelizzare i calcoli all'interno della CPU, per cui una singola operazione viene eseguita su più elementi di dati contemporaneamente. Le moderne architetture della CPU contengono set di istruzioni che possono farlo, operando su molti variabili contemporaneamente. Questo non rende ogni ciclo più veloce. In particolare, si noti che l'utilizzo di SIMD implica che l'ordine delle operazioni all'interno e attraverso il ciclo potrebbe cambiare. Il compilatore deve essere certo che il riordino sia sicuro prima che tenti di parallelizzare un ciclo

## Tasks
Un **Task** è semplicemente un insieme di istruzioni che possono essere sospese e riprese in qualsiasi momento all'interno di quell'insieme. Una funzione può anche essere pensata come un insieme di istruzioni, e quindi di attività può essere visto come qualcosa di simile. Ma ci sono due differenze fondamentali:
* Non c'è overhead per passare da un Task all'altro, il che significa che non viene riservato spazio nello stack per un cambio;
* a differenza di una funzione che deve terminare prima che il controllo torni al chiamante, un Task può essere interrotto e il controllo può essere passato a un altro Task in molti momenti diversi durante la sua esecuzione. In altre parole, nelle attività non esiste una relazione gerarchica chiamante-chiamato. Questo da l'impressione di lavorare in parallelo.


## Threads

I **Thread** sono sequenze di calcolo che possono essere eseguite indipendentemente su un core della CPU, contemporaneamente ad altre sequenze simili. A differenza dei task, che sono leggeri, i thread devono memorizzare uno stato quando vengono scambiati. Così, mentre si possono avere centinaia o migliaia di task in esecuzione, è opportuno avere solamente un numero limitato di Thread, tipicamente pari al numero di core della macchina in uso.