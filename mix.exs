defmodule WebcamfornoloBackend.Mixfile do
  use Mix.Project

  def project do
    [
      app: :webcamfornolo_backend,
      version: "0.0.1",
      elixir: ">= 1.7.3",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {WebcamfornoloBackend.Application, []},
      extra_applications: [:logger, :runtime_tools, :plug]
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
      {:ecto_sql, "~> 3.0.3"},
      {:postgrex, ">= 0.0.0"},
      {:jason, "~> 1.1"},
      {:gettext, "~> 0.11"},
      {:plug_cowboy, "~> 2.0.1"},
      {:httpoison, "~> 1.0"},
      {:safeexstruct, git: "git://github.com/simoexpo/SafeExStruct.git", tag: "v0.4.0"},
      {:elixatmo, git: "git://github.com/simoexpo/ElixAtmo.git", tag: "v0.3.0"},
      {:timex, "~> 3.4.2"},
      {:cachex, "~> 3.0"},
      {:mogrify, "~> 0.7.0"},
      {:elixir_uuid, "~> 1.2"}
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
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test --trace"]
    ]
  end
end
