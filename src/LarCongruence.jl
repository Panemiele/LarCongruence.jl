## [CPD22-7a] COMPONENTI DEL GRUPPO
## Gabriele Romualdi 521111
## Simone Chilosi 522155

module LarCongruence
	using DataStructures
	using LinearAlgebraicRepresentation
	using NearestNeighbors
	using SparseArrays
	using GraphBLASInterface
	using SuiteSparseGraphBLAS
	using SparseMM
	Lar = LinearAlgebraicRepresentation

	include("./verticesCongruence.jl")
	include("./cea-AA.jl")
	include("./cea-SM.jl")
	include("./cea-GB.jl")

	include("./verticesCongruence-optimized.jl")
	include("./cea-SM-optimized.jl")
	include("./cea-GB-optimized.jl")

	export chainCongruenceSM, chainCongruenceAA, chainCongruenceGB
end
