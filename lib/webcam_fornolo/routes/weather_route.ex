defmodule WebcamFornolo.Route.WeatherRoute do
  use Plug.Router

  alias WebcamFornolo.Service

  @weather_service Service.WeatherService

  plug(:match)
  plug(:dispatch)

  get "/weather" do
    weather_provider = Map.get(conn.assigns, :provider, @weather_service)

    case weather_provider.get_weather_info do
      {:ok, resp} -> send_resp(conn, 200, Jason.encode!(resp))
      :error -> send_resp(conn, 500, "")
    end
  end
end
