# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :webcamfornolo_backend,
  ecto_repos: [WebcamfornoloBackend.Repo]

# Configures the endpoint
config :webcamfornolo_backend, WebcamfornoloBackendWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "fEm8m+GtOIPnd1ue0euLgls2qtlvm21RNBvY7urFE8WzSxNNghDunTgDrGFjK8Jj",
  render_errors: [view: WebcamfornoloBackendWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: WebcamfornoloBackend.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Cache
config :webcamfornolo_backend,
  app_cache: :webcam_fornolo_cache

config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
