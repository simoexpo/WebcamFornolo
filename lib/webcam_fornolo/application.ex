defmodule WebcamFornolo.Application do
  use Application

  require Logger

  @default_port "4000"

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    # Define workers and child supervisors to be supervised
    port = String.to_integer(Map.get(System.get_env(), "PORT", @default_port))
    Logger.info("Starting server on port #{port}")

    children = [
      # Start Cowboy web server
      {Bandit, plug: WebcamFornolo.Routes, scheme: :http, ip: {0, 0, 0, 0}, port: port},
      # Start the Ecto repository
      WebcamFornolo.Dal.Db.Repo,
      # Start the endpoint when the application starts
      # supervisor(WebcamFornolo.Endpoint, []),
      # Start your own worker by calling: WebcamFornolo.Worker.start_link(arg1, arg2, arg3)
      # worker(WebcamFornolo.Worker, [arg1, arg2, arg3]),
      Supervisor.child_spec(
        {Cachex, Application.get_env(:webcam_fornolo, :app_cache)},
        id: Application.get_env(:webcam_fornolo, :app_cache)
      ),
      Supervisor.child_spec(
        {Cachex, Application.get_env(:webcam_fornolo, :auth_cache)},
        id: Application.get_env(:webcam_fornolo, :auth_cache)
      )
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: WebcamFornolo.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
