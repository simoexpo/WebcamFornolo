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
  webcam1_port: "8000",
  webcam2_port: "8000",
  webcam_user: "user"


try do
  import_config "test.secret.exs"
rescue
  _ ->
    config :elixatmo,
      app_id: Map.get(System.get_env(), "NETATMO_APP_ID", ""),
      client_secret: Map.get(System.get_env(), "NETATMO_CLIENT_SECRET", ""),
      user_email: Map.get(System.get_env(), "NETATMO_USER_EMAIL", ""),
      user_password: Map.get(System.get_env(), "NETATMO_USER_PASSWORD", ""),
      default_refresh_token: Map.get(System.get_env(), "NETATMO_DEFAULT_REFRESH_TOKEN", "")

    config :ex_aws,
      access_key_id: Map.get(System.get_env(), "AWS_ACCESS_KEY_ID", ""),
      secret_access_key: Map.get(System.get_env(), "AWS_SECRET_ACCESS_KEY", "")

    config :ex_aws, :s3,
      scheme: "https://",
      host: Map.get(System.get_env(), "S3_HOST", "s3.tebi.io")

    config :webcam_fornolo,
      altervista_ftp_user: Map.get(System.get_env(), "ALTERVISTA_USER", ""),
      altervista_ftp_password: Map.get(System.get_env(), "ALTERVISTA_PASSWORD", ""),
      s3_bucket_access_key: Map.get(System.get_env(), "S3_ACCESS_KEY", ""),
      s3_bucket_secret_key: Map.get(System.get_env(), "S3_SECRET_KEY", ""),
      ssh_key: Map.get(System.get_env(), "SSH_KEY", "")
end
