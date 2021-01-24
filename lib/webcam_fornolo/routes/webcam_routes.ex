defmodule WebcamFornolo.Routes.WebcamRoutes do
  use Plug.Router
  require Logger

  import WebcamFornolo.Routes.Plug.Authentication, only: [validate_token: 2]

  alias WebcamFornolo.Service
  alias WebcamFornolo.Mapper.MediaFileMapper

  @webcam_provider_key :webcam_provider
  @default_webcam_provider Service.WebcamImageService

  plug(:match)
  plug(:validate_token, builder_opts())
  plug(:dispatch)

  get "/webcam/:id" do
    webcam_provider = get_webcam_provider(conn)

    case webcam_provider.get_webcam(id) do
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
    webcam_provider = get_webcam_provider(conn)
    # case id do
    #  @webcam1 -> Logger.info("Saving webcam #{id} image")
    #  @webcam2 -> Logger.info("Saving webcam #{id} image")
    #  _ -> Logger.error("Webcam not found")
    # end

    {:ok, webcam_image} =
      Map.from_struct(conn.params["image"])
      |> MediaFileMapper.from()

    case webcam_provider.save_webcam(id, webcam_image) do
      :ok ->
        send_resp(conn, 201, "")

      :notfound ->
        send_resp(conn, 404, "")

      :error ->
        send_resp(conn, 500, "")
    end
  end

  defp get_webcam_provider(conn) do
    Map.get(conn.assigns, @webcam_provider_key, @default_webcam_provider)
  end
end
