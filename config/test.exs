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

config :elixatmo,
  app_id: Map.fetch!(System.get_env(), "NETATMO_APP_ID"),
  client_secret: Map.fetch!(System.get_env(), "NETATMO_CLIENT_SECRET"),
  user_email: Map.fetch!(System.get_env(), "NETATMO_USER_EMAIL"),
  user_password: Map.fetch!(System.get_env(), "NETATMO_USER_PASSWORD")

import_config "test.secret.exs"
