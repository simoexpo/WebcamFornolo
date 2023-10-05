import Config

# Database configuration
config :webcam_fornolo, WebcamFornolo.Dal.Db.Repo,
  url: System.get_env("DATABASE_URL")

# ElixAtmo configurtion to access netatmo weather station
config :elixatmo,
  app_id: System.get_env("NETATMO_APP_ID"),
  client_secret: System.get_env("NETATMO_CLIENT_SECRET"),
  user_email: System.get_env("NETATMO_USER_EMAIL"),
  user_password: System.get_env("NETATMO_USER_PASSWORD"),
  default_refresh_token: System.get_env("NETATMO_DEFAULT_REFRESH_TOKEN")

config :ex_aws,
  access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
  secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY")

#S3 bucket config
config :ex_aws, :s3,
  scheme: "https://",
  host: System.get_env("S3_HOST")

# Atervista configuration for ftp storage
config :webcam_fornolo,
  altervista_ftp_user: System.get_env("ALTERVISTA_USER"),
  altervista_ftp_password: System.get_env("ALTERVISTA_PASSWORD"),
  s3_bucket_access_key: System.get_env("S3_ACCESS_KEY"),
  s3_bucket_secret_key: System.get_env("S3_SECRET_KEY"),
  authorization_token: System.get_env("AUTHORIZATION_TOKEN"),
  admin_password: System.get_env("ADMIN_PASSWORD"),
  webcam_ip: System.get_env("WEBCAM_IP"),
  webcam1_port: System.get_env("WEBCAM1_PORT"),
  webcam2_port: System.get_env("WEBCAM2_PORT"),
  webcam_user: System.get_env("WEBCAM_USER"),
  ssh_key: System.get_env("SSH_KEY")
