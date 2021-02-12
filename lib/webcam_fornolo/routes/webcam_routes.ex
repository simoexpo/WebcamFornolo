defmodule WebcamFornolo.Routes.WebcamRoutes do
  use Plug.Router
  require Logger

  alias WebcamFornolo.Service.Media.WebcamImageService
  alias WebcamFornolo.Mapper.MediaFileMapper
  alias WebcamFornolo.Routes.WebcamRoutes

  @webcam_provider_key :webcam_provider
  @default_webcam_provider WebcamImageService

  defmodule PublicRoutes do
    use Plug.Router

    plug(:match)
    plug(:dispatch)

    get "/webcam/:id" do
      webcam_provider = WebcamRoutes.get_webcam_provider(conn)

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
  end

  defmodule SecuredRoutes do
    use Plug.Router

    import WebcamFornolo.Routes.Plug.Authentication, only: [validate_token: 2]

    plug(:match)
    plug(:validate_token, builder_opts())
    plug(:dispatch)

    post "/webcam/:id" do
      webcam_provider = WebcamRoutes.get_webcam_provider(conn)

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
  end

  plug(:match)
  plug(:dispatch)

  get("/webcam/:id", to: PublicRoutes)

  post("/webcam/:id", to: SecuredRoutes)

  match _ do
    send_resp(conn, 404, "")
  end

  def get_webcam_provider(conn) do
    Map.get(conn.assigns, @webcam_provider_key, @default_webcam_provider)
  end
end
