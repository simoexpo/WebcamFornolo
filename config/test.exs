use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :webcamfornolo_backend, WebcamfornoloBackendWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :webcamfornolo_backend, WebcamfornoloBackend.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "user",
  password: "pass",
  database: "webcamfornolo_backend_dev",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
