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
  admin_password: "password",
  webcam_ip: "127.0.0.1",
  webcam_port1: "8000",
  webcam_port2: "8000",
  webcam_user: "user"


try do
  import_config "test.secret.exs"
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
