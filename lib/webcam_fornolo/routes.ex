defmodule WebcamFornolo.Routes do
  use Plug.Router
  use Plug.ErrorHandler

  require Logger

  alias WebcamFornolo.Routes

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

    plug(WebcamFornolo.Routes.Plug.Cors)

    plug(:dispatch)

    match("/health", via: :get, to: Routes.HealthRoute)

    match("/login", via: :post, to: Routes.AuthRoute)

    match("/logout", via: :post, to: Routes.AuthRoute)

    match("/weather", via: :get, to: Routes.WeatherRoute)

    match("/webcam/*_path", via: [:get, :post], to: Routes.WebcamRoutes)

    match("/media/*_path", via: [:get, :post, :delete], to: Routes.MediaRoutes)

    match _ do
      send_resp(conn, 404, "")
    end
  end

  defmodule StaticAssetRoutes do
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
  plug(:assign_options, builder_opts())
  plug(:dispatch)

  forward("/api", to: ApiRoutes)

  forward("/", to: StaticAssetRoutes)

  defp assign_options(conn, opts) do
    Enum.reduce(opts, conn, fn {key, value}, acc -> Plug.Conn.assign(acc, key, value) end)
  end
end
