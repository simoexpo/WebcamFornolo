defmodule WebcamFornolo.Route.WebcamRoutes do
  use Plug.Router
  require Logger

  alias WebcamFornolo.Service
  alias WebcamFornolo.Mapper.MediaFileMapper

  #@webcam1 "1"
  #@webcam2 "2"
  @webcam_image_service Service.WebcamImageService

  plug :match
  plug Plug.Parsers, parsers: [:urlencoded, :multipart, :json], json_decoder: Jason
  plug :dispatch

  get "/webcam/:id" do
    webcam_image_service = Map.get(conn.assigns, :provider, @webcam_image_service)
    case webcam_image_service.get_webcam(id) do
      {:ok, filename} -> send_file(conn, 200, filename)
      :notfound -> send_resp(conn, 404, "")
        # conn
        # |> CommonController.add_common_headers()
        #|> put_resp_header("Content-Type", "image/jpeg")
       # |> send_file(200, url)
      :error -> send_resp(conn, 500, "")
        # conn
        # |> CommonController.add_common_headers()
        #|> put_status(404)
        #|> json(%{error: "Webcam #{id} is unavailable"})
    end
  end

  post "/webcam/:id" do
    webcam_image_service = Map.get(conn.assigns, :provider, @webcam_image_service)
    # case id do
    #  @webcam1 -> Logger.info("Saving webcam #{id} image")
    #  @webcam2 -> Logger.info("Saving webcam #{id} image")
    #  _ -> Logger.error("Webcam not found")
    #end

    {:ok, webcam_image} =
      Map.from_struct(conn.params["image"])
      |> MediaFileMapper.from

    case webcam_image_service.save_webcam(id, webcam_image) do
      :ok -> send_resp(conn, 201, "")
      :notfound -> send_resp(conn, 404, "")
        # conn
        # |> CommonController.add_common_headers()
        #|> put_status(201)
        #|> json(%{})
      :error -> send_resp(conn, 500, "")
        # conn
        # |> CommonController.add_common_headers()
        #|> put_status(500)
        #|> json(%{})
    end
  end
end
