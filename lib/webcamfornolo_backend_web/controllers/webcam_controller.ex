defmodule WebcamfornoloBackendWeb.WebcamController do
  use WebcamfornoloBackendWeb, :controller

  @webcam1 "1"
  @webcam2 "2"

  def get_webcam(conn, params) do
    id = get_webcam_id(params)

    case id do
      @webcam1 -> IO.puts("Getting webcam #{id} image")
      @webcam2 -> IO.puts("Getting webcam #{id} image")
      _ -> IO.puts("Webcam not found")
    end

    json(conn, %{status: "Ok 1"})
  end

  def save_webcam(conn, params) do
    id = get_webcam_id(params)

    case id do
      @webcam1 -> IO.puts("Saving webcam #{id} image")
      @webcam2 -> IO.puts("Saving webcam #{id} image")
      _ -> IO.puts("Webcam not found")
    end

    url = Map.from_struct(params["image"])[:path]
    json(conn, %{image: url})
  end

  defp get_webcam_id(param) do
    Map.get(param, "id")
  end
end
