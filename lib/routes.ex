defmodule WebcamFornolo.Routes do
  use Plug.Router
  use Plug.ErrorHandler

  alias  WebcamFornolo.Route
  alias WebcamFornolo.Service

  plug :match
  plug :dispatch

  match "/health", to: Route.HealthRoute

  match "/weather", to: Route.WeatherRoute

  match "/webcam/*_path", to: Route.WebcamRoutes

  match "/media/*_path", to: Route.MediaRoutes

  match _ do
    send_resp(conn, 404, "")
  end

  defp handle_errors(conn, %{kind: kind, reason: reason, stack: stack}) do
    IO.inspect(kind, label: :kind)
    IO.inspect(reason, label: :reason)
    IO.inspect(stack, label: :stack)
    send_resp(conn, conn.status, "Something went wrong")
  end
end
