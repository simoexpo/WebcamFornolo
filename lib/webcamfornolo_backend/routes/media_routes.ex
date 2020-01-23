defmodule WebcamFornolo.Route.MediaRoutes do
  use Plug.Router
  require Logger

  alias WebcamFornolo.Service
  alias WebcamFornolo.Mapper.MediaFileMapper

  @webcam1 "1"
  @webcam2 "2"
  @media_service Service.MediaService

  plug :match
  plug Plug.Parsers, parsers: [:urlencoded, :multipart, :json], json_decoder: Jason
  plug :dispatch

  get "/media" do
    Logger.info("get paginated media")
    page = String.to_integer(Map.get(conn.params, "page", "0"))
    rpp = String.to_integer(Map.get(conn.params, "rpp", "10"))
    media_service = Map.get(conn.assigns, :provider, @media_service)

    case media_service.get_media_paginated(page, rpp) do
      {:ok, page} ->
        page_view = Map.update!(page, :items, fn items -> Enum.map(items, &Map.from_struct/1) end)
        # conn |> CommonController.add_common_headers() #|> put_status(200)# |> json(page_view)
        send_resp(conn, 200, Jason.encode!(page_view))

      :error ->
        # conn |> CommonController.add_common_headers() #|> put_status(500)
        send_resp(conn, 500, "")
    end
  end

  post "/media" do
    Logger.info("save media")
    media_service = Map.get(conn.assigns, :provider, @media_service)

    {:ok, media} =
      Map.from_struct(conn.params["image"])
      |> Map.put(:description, conn.params["description"])
      |> MediaFileMapper.from

    case media_service.save_media(media) do
      :ok ->
        # conn |> CommonController.add_common_headers() #|> put_status(201)
        send_resp(conn, 201, "")

      :error ->
        # conn |> CommonController.add_common_headers() #|> put_status(500)
        send_resp(conn, 500, "")
    end
  end

  delete "/media/:id" do
    Logger.info("delete media #{id}")
    media_service = Map.get(conn.assigns, :provider, @media_service)

    case media_service.delete_media(id) do
      :ok ->
        # conn |> CommonController.add_common_headers() #|> put_status(204)
        send_resp(conn, 204, "")

      :notfound ->
        send_resp(conn, 404, "")

      :error ->
        # conn |> CommonController.add_common_headers() #|> put_status(404)
        send_resp(conn, 500, "")
    end
  end
end
