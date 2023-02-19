defmodule EctoMySQLMatch.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/timothyvanderaerden/ecto_mysql_match"

  def project do
    [
      app: :ecto_mysql_match,
      version: @version,
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      name: "Ecto MySQL Match",
      description: "Ecto MySQL (and MariaDB) fulltext search.",
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: preferred_cli_env(),
      package: package(),
      docs: docs(),
      deps: deps()
    ]
  end

  defp preferred_cli_env() do
    [
      coveralls: :test,
      "coveralls.detail": :test,
      "coveralls.post": :test,
      "coveralls.html": :test,
      "coveralls.json": :test
    ]
  end

  defp package() do
    [
      maintainers: ["Timothy Vanderaerden"],
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => @source_url}
    ]
  end

  defp docs() do
    [
      extras: [
        "CHANGELOG.md": [],
        LICENSE: [title: "License"],
        "README.md": [title: "Overview"]
      ],
      main: "readme",
      source_url: @source_url,
      source_ref: "v#{@version}",
      formatters: ["html"]
    ]
  end

  defp deps do
    [
      {:ecto_sql, "~> 3.9"},

      # Development
      {:credo, "~> 1.5", only: :dev, runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:excoveralls, "~> 0.14", only: :test},
      {:myxql, "~> 0.6", only: :test}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
