defmodule WebcamFornolo.Mixfile do
  use Mix.Project

  def project do
    [
      app: :webcam_fornolo,
      version: "0.0.1",
      elixir: "~> 1.11.0",
      elixirc_paths: elixirc_paths(Mix.env()),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      dialyzer: [
        plt_add_apps: [:ftp, :inets],
        paths: ["_build/dev/lib/webcam_fornolo/ebin"]
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {WebcamFornolo.Application, []},
      extra_applications: [:logger, :runtime_tools, :plug_cowboy]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:ecto_sql, "~>  3.5.3"},
      {:postgrex, ">= 0.0.0"},
      {:jason, "~> 1.2.2"},
      {:plug_cowboy, "~> 2.4.1"},
      {:safeexstruct, git: "git://github.com/simoexpo/SafeExStruct.git", tag: "v0.4.0"},
      {:elixatmo, git: "git://github.com/simoexpo/ElixAtmo.git", tag: "v0.4.0"},
      # temp fix
      {:hackney, github: "benoitc/hackney", override: true},
      {:timex, "~> 3.6.2"},
      {:cachex, "~> 3.3.0"},
      {:mogrify, "~> 0.8.0"},
      {:elixir_uuid, "~> 1.2.1"},
      {:dialyxir, "~> 1.0.0", only: [:dev], runtime: false},
      {:excoveralls, "~> 0.13.4", only: [:test]}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"]
      # test: ["ecto.create --quiet", "ecto.migrate", "test --trace"]
    ]
  end
end
