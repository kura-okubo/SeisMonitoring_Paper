using Documenter

push!(LOAD_PATH,"../src/")

makedocs(
	# format = Documenter.HTML(prettyurls = false),
    sitename = "SeisMonitoring Paper",
    pages = [
	"Index" => "index.md",
	"Run examples" => "run_example.md",
	"Download CFs" => "download_correlations.md",
    "Recipe of figures" => "plot_figures_recipe.md"
    ])

deploydocs(
    repo = "github.com/kura-okubo/SeisMonitoring_Paper.jl.git",
)
