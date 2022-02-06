import Config

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
# config :phoenix, :stacktrace_depth, 20

# Database configuration
config :webcam_fornolo, WebcamFornolo.Dal.Db.Repo,
  username: "user",
  password: "pass",
  database: "webcam_fornolo_dev",
  hostname: "localhost",
  pool_size: 15

try do
  import_config "dev.secret.exs"
rescue
  x ->
    config :elixatmo,
      app_id: Map.get(System.get_env(), "NETATMO_APP_ID", ""),
      client_secret: Map.get(System.get_env(), "NETATMO_CLIENT_SECRET", ""),
      user_email: Map.get(System.get_env(), "NETATMO_USER_EMAIL", ""),
      user_password: Map.get(System.get_env(), "NETATMO_USER_PASSWORD", "")

    config :webcam_fornolo,
      altervista_ftp_user: Map.get(System.get_env(), "ALTERVISTA_USER", ""),
      altervista_ftp_password: Map.get(System.get_env(), "ALTERVISTA_PASSWORD", "")
end
