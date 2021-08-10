defmodule WebcamFornolo.Application do
  use Application

  require Logger

  alias Membrane.RTSP
  alias Membrane.RTSP.Response

  @default_port "4000"

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    # Define workers and child supervisors to be supervised
    port = String.to_integer(Map.get(System.get_env(), "PORT", @default_port))
    Logger.info("Starting server on port #{port}")

    session = RTSP.Session.start_link("rtsp://FornoloFoscam2:pass@ls1927.myfoscam.org:88")
    asd(session)

    children = [
      # Start Cowboy web server
      {Plug.Cowboy, scheme: :http, plug: WebcamFornolo.Routes, port: port},
      # Start the Ecto repository
      # WebcamFornolo.Dal.Db.Repo,
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

  def asd(session) do
    {:ok, desc} = RTSP.describe(session)
    IO.inspect(desc)
    {:ok, %Response{status: 200}} = RTSP.setup(session, "/videoMain", [])

    {:ok, %Response{status: 200, body: body}} = RTSP.play(session)

    IO.inspect(body)
  end
end
