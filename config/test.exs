import Config

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :webcam_fornolo, WebcamFornolo.Dal.Db.Repo,
  username: "user",
  password: "pass",
  database: "webcam_fornolo_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :webcam_fornolo,
  authorization_token: "remove_me",
  admin_password: "password"

try do
  import_config "test.secret.exs"
rescue
  x ->
    config :elixatmo,
      app_id: Map.fetch!(System.get_env(), "NETATMO_APP_ID"),
      client_secret: Map.fetch!(System.get_env(), "NETATMO_CLIENT_SECRET"),
      user_email: Map.fetch!(System.get_env(), "NETATMO_USER_EMAIL"),
      user_password: Map.fetch!(System.get_env(), "NETATMO_USER_PASSWORD")

    config :webcam_fornolo,
      altervista_ftp_user: Map.fetch!(System.get_env(), "ALTERVISTA_USER"),
      altervista_ftp_password: Map.fetch!(System.get_env(), "ALTERVISTA_PASSWORD")
end
