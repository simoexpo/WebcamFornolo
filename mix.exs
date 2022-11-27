defmodule WebcamFornolo.Mixfile do
  use Mix.Project

  def project do
    [
      app: :webcam_fornolo,
      version: "0.0.1",
      elixir: ">= 1.12.3",
      elixirc_paths: elixirc_paths(Mix.env()),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      dialyzer: [
        plt_add_apps: [:ftp],
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
      extra_applications: [:logger, :runtime_tools, :plug_cowboy, :ftp]
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
      {:ecto_sql, "~>  3.9.1"},
      {:postgrex, ">= 0.0.0"},
      {:jason, "~> 1.2.2"},
      {:plug_cowboy, "~> 2.6.0"},
      {:safeexstruct, github: "simoexpo/SafeExStruct", tag: "v0.4.0", override: true},
      {:elixatmo, github: "simoexpo/ElixAtmo", tag: "v0.4.0"},
      # temp fix
      {:hackney, github: "benoitc/hackney", override: true},
      {:timex, "~> 3.7.9"},
      {:cachex, "~> 3.4.0"},
      {:mogrify, "~> 0.9.2"},
      {:elixir_uuid, "~> 1.2.1"},
      {:ssh_client_key_api, "~> 0.2.0"},
      {:sshkit, "~> 0.1"},
      {:dialyxir, "~> 1.2.0", only: [:dev], runtime: false},
      {:excoveralls, "~> 0.15.0", only: [:test]},
      {:credo, "~> 1.6.7", only: [:dev, :test], runtime: false}
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
