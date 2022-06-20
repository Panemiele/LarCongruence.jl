using Documenter, LarCongruence
LC = LarCongruence

Documenter.makedocs(
	modules = [LarCongruence],
    format = Documenter.HTML(
        assets = ["assets/LAR_Congruence.css"],
        highlights = ["yaml"],
	),
	clean = true,
	sitename = "LarCongruence.jl",
	authors = "Gabriele Romualdi and Simone Chilosi.",
	pages = [
		"Home" => "index.md",
		"Introduzione" => "theory.md",
		"Grafo delle dipendenze" => "grafoDipendenze.md",
		"Sviluppo" => "sviluppo.md",
		"Codice Sorgente e funzioni" => [
			"Vertices Congruence" => "documentazioni/verticesCongruence.md",
			"Sparse Matrix" => "documentazioni/sparseMatrix.md",
			"GraphBLAS" => "documentazioni/graphBLAS.md",
			"Array of Arrays" => "documentazioni/arrayOfArrays.md",
		],
		"Esempi e risultati" => "esempi.md",
		"Autori" => "authors.md",
	]
)



deploydocs(
    repo="github.com/Panemiele/LarCongruence.jl.git",
    versions = nothing,
)
