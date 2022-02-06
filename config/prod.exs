import Config

# Database configuration
config :webcam_fornolo, WebcamFornolo.Dal.Db.Repo,
  url: Map.fetch!(System.get_env(), "DATABASE_URL"),
  pool_size: 15,
  ssl: true

# Do not print debug messages in production
config :logger, level: :info

# ElixAtmo configurtion to access netatmo weather station
config :elixatmo,
  app_id: Map.fetch!(System.get_env(), "NETATMO_APP_ID"),
  client_secret: Map.fetch!(System.get_env(), "NETATMO_CLIENT_SECRET"),
  user_email: Map.fetch!(System.get_env(), "NETATMO_USER_EMAIL"),
  user_password: Map.fetch!(System.get_env(), "NETATMO_USER_PASSWORD")

# Atervista configuration for ftp storage
config :webcam_fornolo,
  altervista_ftp_user: Map.fetch!(System.get_env(), "ALTERVISTA_USER"),
  altervista_ftp_password: Map.fetch!(System.get_env(), "ALTERVISTA_PASSWORD"),
  authorization_token: Map.fetch!(System.get_env(), "AUTHORIZATION_TOKEN"),
  admin_password: Map.fetch!(System.get_env(), "ADMIN_PASSWORD")
  webcam_ip: Map.fetch!(System.get_env(), "WEBCAM_IP"),
  webcam_port1: Map.fetch!(System.get_env(), "WEBCAM_PORT1"),
  webcam_port2: Map.fetch!(System.get_env(), "WEBCAM_PORT2"),
  webcam_user: Map.fetch!(System.get_env(), "WEBCAM_USER")
