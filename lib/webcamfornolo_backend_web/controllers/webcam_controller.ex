defmodule WebcamfornoloBackendWeb.WebcamController do
  use WebcamfornoloBackendWeb, :controller
  require Logger

  @webcam1 "1"
  @webcam2 "2"

  def get_webcam(conn, params) do
    id = get_webcam_id(params)

    case WebcamfornoloBackend.get_webcam(id) do
      :error ->
        conn
        |> put_status(404)
        |> json(%{error: "Webcam #{id} is unavailable"})

      url ->
        conn
        |> put_resp_header("Content-Type", "image/jpeg")
        |> send_file(200, url)
    end
  end

  def save_webcam(conn, params) do
    id = get_webcam_id(params)

    case id do
      @webcam1 -> IO.puts("Saving webcam #{id} image")
      @webcam2 -> IO.puts("Saving webcam #{id} image")
      _ -> Logger.error("Webcam not found")
    end

    webcam_image = Map.from_struct(params["image"])

    case WebcamfornoloBackend.save_webcam(id, webcam_image) do
      :error ->
        conn
        |> put_status(500)
        |> json(%{})

      :ok ->
        conn
        |> put_status(201)
        |> json(%{})
    end
  end

  defp get_webcam_id(param) do
    Map.get(param, "id")
  end
end
