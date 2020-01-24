defmodule WebcamfornoloBackendWeb.WebcamController do
  #use WebcamfornoloBackendWeb, :controller
  alias WebcamfornoloBackendWeb.CommonController
  require Logger

  @webcam1 "1"
  @webcam2 "2"

  def get_webcam(conn, params) do
    id = get_webcam_id(params)

  #  case WebcamfornoloBackend.get_webcam(id) do
  #    :error ->
  #      conn
  #      |> CommonController.add_common_headers()
        #|> put_status(404)
        #|> json(%{error: "Webcam #{id} is unavailable"})

  #    url ->
  #      conn
  #      |> CommonController.add_common_headers()
        #|> put_resp_header("Content-Type", "image/jpeg")
       # |> send_file(200, url)
  #  end
  end

  def save_webcam(conn, params) do
    id = get_webcam_id(params)

    case id do
      @webcam1 -> Logger.info("Saving webcam #{id} image")
      @webcam2 -> Logger.info("Saving webcam #{id} image")
      _ -> Logger.error("Webcam not found")
    end

    webcam_image = Map.from_struct(params["image"])

  #  case WebcamfornoloBackend.save_webcam(id, webcam_image) do
  ##    :error ->
  #      conn
  #      |> CommonController.add_common_headers()
        #|> put_status(500)
        #|> json(%{})

  #    :ok ->
  #      conn
  #      |> CommonController.add_common_headers()
        #|> put_status(201)
        #|> json(%{})
  #  end
  end

  defp get_webcam_id(param) do
    Map.get(param, "id")
  end
end
