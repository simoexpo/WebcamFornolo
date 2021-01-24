defmodule WebcamFornolo.Routes.WeatherRoute do
  use Plug.Router

  alias WebcamFornolo.Service

  @weather_provider_key :weather_provider
  @default_weather_provider Service.WeatherService

  plug(:match)
  plug(:dispatch)

  get "/weather" do
    weather_provider = get_weather_provider(conn)

    with {:ok, resp} <- weather_provider.get_weather_info,
         {:ok, json} <- Jason.encode(resp) do
      conn |> put_resp_header("content-type", "application/json") |> send_resp(200, json)
    else
      _ -> send_resp(conn, 500, "")
    end
  end

  defp get_weather_provider(conn) do
    Map.get(conn.assigns, @weather_provider_key, @default_weather_provider)
  end
end
