defmodule WebcamFornolo.Route.WeatherRoute do
  use Plug.Router

  alias WebcamFornolo.Service

  @weather_service Service.WeatherService

  plug(:match)
  plug(:dispatch)

  get "/weather" do
    weather_provider = Map.get(conn.assigns, :provider, @weather_service)

    with {:ok, resp} <- weather_provider.get_weather_info,
         {:ok, json} <- Jason.encode(resp) do
      conn |> put_resp_header("content-type", "application/json") |> send_resp(200, json)
    else
      _ -> send_resp(conn, 500, "")
    end
  end
end
