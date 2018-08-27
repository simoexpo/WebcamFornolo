defmodule WebcamfornoloBackendWeb.WeatherController do
  use WebcamfornoloBackendWeb, :controller
  import WebcamfornoloBackendWeb.Util.ControllerHelper

  def get_weather(conn, _params) do
    case WebcamfornoloBackend.get_weather_info() do
      {:ok, data} ->
        conn
        |> add_common_headers()
        |> put_status(200)
        |> json(data)

      :error ->
        conn |> add_common_headers() |> put_status(500) |> json(%{})
    end
  end
end
