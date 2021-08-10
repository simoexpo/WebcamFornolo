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

    username = "FornoloFoscam"
    password = "Seragele01%"

    # username1 = "fornolo"
    # password1 = "fornolo1"

    session = RTSP.Session.start_link("rtsp://#{username}:#{password}@81.174.23.123:8001/videoMain")

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
    # IO.inspect(session.manager)
    # {:ok, %Response{status: 200}} = RTSP.describe(session)
    {:ok, desc1} = RTSP.options(session)

    {:ok, desc2} = RTSP.describe(session)

    {:ok, desc3} = RTSP.options(session)

    {:ok, desc4} = RTSP.describe(session)


    # {:ok, desc2} = RTSP.describe(session)
    IO.inspect(desc1)
    # IO.inspect(session)

    IO.inspect(desc2)

    IO.inspect(desc3)

    IO.inspect(desc4)


    {:ok, %Response{status: 200}} = RTSP.setup(session, "/", [{"Transport", "RTP/AVP;unicast;client_port=57614-57615"}])

    {:ok, %Response{status: 200, body: body}} = RTSP.play(session)

    IO.inspect(body)
  end
end
