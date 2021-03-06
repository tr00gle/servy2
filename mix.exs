defmodule Servy2.MixProject do
  use Mix.Project

  def project do
    [
      app: :servy2,
      version: "0.1.0",
      elixir: "~> 1.9.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      dialyzer: [
        plt_add_apps: [:mix, :ex_unit],
        remove_defaults: [:unknown]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.0.0", only: [:dev, :test], runtime: false},
      {:poison, "~> 4.0"},
      {:httpoison, "~> 1.5"},
      {:earmark, "~> 1.3"},
      {:excoveralls, "~> 0.10", only: :test},
      {:dialyxir, "~> 1.0.0-rc.6", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.19", only: [:dev, :test], runtime: false}
    ]
  end
end
