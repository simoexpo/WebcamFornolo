defmodule WebcamFornolo.Routes.MediaRoutes do
  use Plug.Router
  require Logger

  alias WebcamFornolo.Service.Media.MediaFileService
  alias WebcamFornolo.Mapper.MediaFileMapper
  alias WebcamFornolo.Routes.MediaRoutes

  @media_provider_key :media_provider
  @default_media_provider MediaFileService

  defmodule PublicRoutes do
    use Plug.Router

    plug(:match)
    plug(:dispatch)

    get "/media" do
      Logger.info("get paginated media")
      page = String.to_integer(Map.get(conn.params, "page", "0"))
      rpp = String.to_integer(Map.get(conn.params, "rpp", "10"))
      media_service = MediaRoutes.get_media_provider(conn)

      case media_service.get_media_paginated(page, rpp) do
        {:ok, page} ->
          page_view = Map.update!(page, :items, fn items -> Enum.map(items, &Map.from_struct/1) end)

          conn
          |> put_resp_header("content-type", "application/json")
          |> send_resp(200, Jason.encode!(page_view))

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

    post "/media" do
      Logger.info("save media")
      media_service = MediaRoutes.get_media_provider(conn)

      {:ok, media} =
        Map.from_struct(conn.params["image"])
        |> Map.put(:description, conn.params["description"])
        |> MediaFileMapper.from()

      case media_service.save_media(media) do
        :ok ->
          send_resp(conn, 201, "")

        :error ->
          send_resp(conn, 500, "")
      end
    end

    delete "/media/:id" do
      Logger.info("delete media #{id}")
      media_service = MediaRoutes.get_media_provider(conn)

      case media_service.delete_media(id) do
        :ok ->
          send_resp(conn, 204, "")

        :notfound ->
          send_resp(conn, 404, "")

        :error ->
          send_resp(conn, 500, "")
      end
    end
  end

  plug(:match)
  plug(:dispatch)

  get("/media", to: PublicRoutes)

  post("/media", to: SecuredRoutes)

  delete("/media/:id", to: SecuredRoutes)

  match _ do
    send_resp(conn, 404, "")
  end

  def get_media_provider(conn) do
    Map.get(conn.assigns, @media_provider_key, @default_media_provider)
  end
end
