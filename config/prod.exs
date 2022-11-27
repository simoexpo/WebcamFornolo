import Config

# Database configuration
config :webcam_fornolo, WebcamFornolo.Dal.Db.Repo,
  pool_size: 10,
  ssl: false,
  socket_options: [:inet6]

# Do not print debug messages in production
config :logger, level: :info
