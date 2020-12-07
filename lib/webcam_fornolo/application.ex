defmodule WebcamfornoloBackend.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      {Plug.Cowboy, scheme: :http, plug: WebcamFornolo.Routes, port: 4000},
      WebcamfornoloBackend.Repo,
      # Start the endpoint when the application starts
      # supervisor(WebcamfornoloBackendWeb.Endpoint, []),
      # Start your own worker by calling: WebcamfornoloBackend.Worker.start_link(arg1, arg2, arg3)
      # worker(WebcamfornoloBackend.Worker, [arg1, arg2, arg3]),
      Supervisor.child_spec(
        {Cachex, Application.get_env(:webcamfornolo_backend, :app_cache)},
        id: Application.get_env(:webcamfornolo_backend, :app_cache)
      ),
      Supervisor.child_spec(
        {Cachex, Application.get_env(:webcamfornolo_backend, :auth_cache)},
        id: Application.get_env(:webcamfornolo_backend, :auth_cache)
      )
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: WebcamfornoloBackend.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
