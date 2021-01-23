import Config

# General application configuration
config :webcam_fornolo,
  ecto_repos: [WebcamFornolo.Dal.Db.Repo]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Cache
config :webcam_fornolo,
  server_port: 4000,
  app_cache: :webcam_fornolo_cache,
  auth_cache: :auth_cache

# config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
