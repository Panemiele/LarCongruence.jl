push!(LOAD_PATH,"../src/")

using Documenter, LarCongruence
LC = LarCongruence

Documenter.makedocs(
	modules = [LocalCongruence],
    format = Documenter.HTML(
        assets = ["assets/LAR_Congruence.css"],
        highlights = ["yaml"],
	),
	clean = true,
	sitename = "LAR_Congruence.jl",
	authors = "Gabriele Romualdi and Simone Chilosi.",
	pages = [
		"1 - Home" => "index.md",
		"2 - Complexes and Chain Operators" => "theory.md",
		"3 - GraphBLAS Introduction" => "graph_blas.md",
		"Cell Congruence Enabling" => [
			"4.1 - Vertices Congruence" => "verticesCongruence.md",
			"4.2 - Chain Complex Congruence" => "chainComplexCongruence.md",
		],
		"Examples" => [
			"5.1 - Cube Grids" => "example_1.md",
			"5.2 - ..." => "example_2.md",
			"5.3 - ..." => "example_3.md",
		],
		"A - About the Authors" => "authors.md",
		"B - Bibliography" => "bibliography.md"
	]
)
