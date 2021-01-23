defmodule WebcamFornolo.Routes do
  use Plug.Router
  use Plug.ErrorHandler

  alias WebcamFornolo.Route

  defmodule ApiRoutes do
    use Plug.Router

    plug(Plug.RequestId)
    plug(Plug.Logger)

    plug(:match)

    plug(Plug.Parsers,
      parsers: [:urlencoded, :multipart, :json],
      pass: ["*/*"],
      json_decoder: Jason
    )

    plug(WebcamFornolo.Cors)

    plug(:dispatch)

    match("/health", to: Route.HealthRoute)

    match("/login", to: Route.AuthRoute)

    match("/logout", to: Route.AuthRoute)

    match("/weather", to: Route.WeatherRoute)

    match("/webcam/*_path", to: Route.WebcamRoutes)

    match("/media/*_path", to: Route.MediaRoutes)

    match _ do
      send_resp(conn, 404, "")
    end
  end

  defmodule FrontendRoutes do
    use Plug.Router

    plug(
      Plug.Static,
      at: "/",
      from: :webcam_fornolo,
      gzip: false,
      only: ~w(css vendor fonts img js robots.txt)
    )

    plug(Plug.RequestId)
    plug(Plug.Logger)

    # Serve at "/" the static files from "priv/static" directory.
    plug(
      Plug.Static,
      at: "/",
      from: :webcam_fornolo,
      gzip: false,
      only: ~w(index.html gallery.html login.html upload.html about.html)
    )

    plug(:match)
    plug(:dispatch)

    get "/" do
      conn |> Plug.Conn.resp(:found, "") |> Plug.Conn.put_resp_header("location", "/index.html")
    end

    match _ do
      send_resp(conn, 404, "")
    end
  end

  plug(:match)
  plug(:dispatch)

  forward("/api", to: ApiRoutes)

  forward("/", to: FrontendRoutes)
end
