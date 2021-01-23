use Mix.Config

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

import_config "dev.secret.exs"
