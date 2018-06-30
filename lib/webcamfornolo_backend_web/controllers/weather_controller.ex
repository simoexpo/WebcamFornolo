defmodule WebcamfornoloBackendWeb.WeatherController do
  use WebcamfornoloBackendWeb, :controller

  def get_weather(conn, _params) do
    case WebcamfornoloBackend.get_weather_info() do
      {:ok, data} -> conn |> put_status(200) |> json(data)
      :error -> conn |> put_status(500) |> json(%{})
    end
  end
end
