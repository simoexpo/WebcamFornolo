defmodule WebcamfornoloBackendWeb.WeatherController do
  use WebcamfornoloBackendWeb, :controller

  @acao_header "Access-Control-Allow-Origin"
  @allowed_origin "https://webcamfornolo.altervista.org"

  def get_weather(conn, _params) do
    case WebcamfornoloBackend.get_weather_info() do
      {:ok, data} ->
        conn
        |> put_status(200)
        |> put_resp_header(@acao_header, @allowed_origin)
        |> json(data)

      :error ->
        conn |> put_status(500) |> json(%{})
    end
  end
end
