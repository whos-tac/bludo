defmodule Bludo.MixProject do
  use Mix.Project

  @version "2.5.0"

  def project do
    [
      app: :bludo,
      version: @version,
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),

      # Docs
      name: "Bludo",
      source_url: "https://bulme.at",
      homepage_url: "https://bulme.at",
      docs: [
        logo: "priv/static/images/bulme-logo-full.png",
        groups_for_modules: [
          "User management": [
            ~r/bludo\.Account\.?/,
            ~r/BludoWeb\.UserRegistration\.?/,
            ~r/BludoWeb\.UserSession\.?/,
            ~r/BludoWeb\.UserLiveAuth\.?/,
            ~r/BludoWeb\.UserConfirmation\.?/,
            ~r/BludoWeb\.UserSettings\.?/,
            ~r/BludoWeb\.UserReset\.?/,
            ~r/BludoWeb\.Attendee\.?/,
            ~r/BludoWeb\.UserAuth\.?/,
            ~r/BludoWeb\.UserView\.?/
          ],
          Events: [
            ~r/bludo\.Event\.?/,
            ~r/BludoWeb\.Event\.?/
          ],
          Forms: [
            ~r/bludo\.Forms\.?/,
            ~r/BludoWeb\.Form\.?/
          ],
          WebContent: [
            ~r/bludo\.Embed\.?/,
            ~r/BludoWeb\.Embed\.?/
          ],
          Polls: [
            ~r/bludo\.Polls\.?/,
            ~r/BludoWeb\.Poll\.?/
          ],
          Posts: [
            ~r/bludo\.Posts\.?/,
            ~r/BludoWeb\.Post\.?/
          ]
        ]
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Bludo.Application, []},
      extra_applications: [:logger, :runtime_tools, :ssl, :porcelain]
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
      {:ex_aws, "~> 2.5"},
      {:ex_aws_s3, "~> 2.5"},
      {:ex_doc, "~> 0.38", only: :dev, runtime: false},
      {:bcrypt_elixir, "~> 3.3"},
      {:phoenix, "~> 1.7"},
      {:phoenix_ecto, "~> 4.6"},
      {:ecto_sql, "~> 3.13"},
      {:postgrex, "~> 0.20.0"},
      {:phoenix_html, "~> 4.2"},
      {:phoenix_html_helpers, "~> 1.0"},
      {:phoenix_live_reload, "~> 1.6", only: :dev},
      {:phoenix_live_view, "~> 1.0"},
      {:phoenix_swoosh, "~> 1.2.1"},
      {:phoenix_view, "~> 2.0"},
      {:floki, ">= 0.36.1", only: :test},
      {:phoenix_live_dashboard, "~> 0.8"},
      {:esbuild, "~> 0.10", runtime: Mix.env() == :dev},
      {:dart_sass, "~> 0.7", runtime: Mix.env() == :dev},
      {:swoosh, "~> 1.19"},
      {:gen_smtp, "~> 1.3"},
      {:finch, "~> 0.19"},
      {:telemetry_metrics, "~> 1.1"},
      {:telemetry_poller, "~> 1.2"},
      {:gettext, "~> 0.26"},
      {:jason, "~> 1.4"},
      {:sweet_xml, "~> 0.7"},
      {:plug_cowboy, "~> 2.7"},
      {:hashids, "~> 2.1"},
      {:libcluster, "~> 3.5"},
      {:porcelain, "~> 2.0"},
      {:csv, "~> 3.2"},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:joken, "~> 2.6"},
      {:jose, "~> 1.11"},
      {:req, "~> 0.5"},
      {:uuid, "~> 1.1"},
      {:oidcc, "~> 3.5"},
      {:oban, "~> 2.19"},
      {:hammer, "~> 7.0"},
      {:flop, "~> 0.26"},
      {:flop_phoenix, "~> 0.25"},
      {:remote_ip, "~> 1.2"},
      {:tailwind, "~> 0.3", runtime: Mix.env() == :dev}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.deploy": [
        "cmd --cd assets npm install",
        "tailwind default --minify",
        "tailwind admin --minify",
        "esbuild default --minify",
        "sass default --no-source-map --style=compressed",
        "phx.digest"
      ]
    ]
  end
end

