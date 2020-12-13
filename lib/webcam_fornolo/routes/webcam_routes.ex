defmodule WebcamFornolo.Route.WebcamRoutes do
  use Plug.Router
  require Logger

  alias WebcamFornolo.Service
  alias WebcamFornolo.Mapper.MediaFileMapper

  @webcam_image_service Service.WebcamImageService

  plug(:match)
  plug(WebcamFornolo.Auth)
  plug(:dispatch)

  get "/webcam/:id" do
    webcam_image_service = Map.get(conn.assigns, :provider, @webcam_image_service)

    case webcam_image_service.get_webcam(id) do
      {:ok, filename} ->
        conn
        |> put_resp_header("content-type", "image/jpeg")
        |> send_file(200, filename)

      :notfound ->
        send_resp(conn, 404, "")

      :error ->
        send_resp(conn, 500, "")
    end
  end

  post "/webcam/:id" do
    webcam_image_service = Map.get(conn.assigns, :provider, @webcam_image_service)
    # case id do
    #  @webcam1 -> Logger.info("Saving webcam #{id} image")
    #  @webcam2 -> Logger.info("Saving webcam #{id} image")
    #  _ -> Logger.error("Webcam not found")
    # end

    {:ok, webcam_image} =
      Map.from_struct(conn.params["image"])
      |> MediaFileMapper.from()

    case webcam_image_service.save_webcam(id, webcam_image) do
      :ok ->
        send_resp(conn, 201, "")

      :notfound ->
        send_resp(conn, 404, "")

      :error ->
        send_resp(conn, 500, "")
    end
  end
end
