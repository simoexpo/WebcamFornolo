use Mix.Config

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :webcam_fornolo, WebcamFornolo.Dal.Db.Repo,
  username: "user",
  password: "pass",
  database: "webcam_fornolo_dev",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
