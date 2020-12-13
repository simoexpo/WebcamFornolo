defmodule WebcamFornolo.Route.MediaRoutes do
  use Plug.Router
  require Logger

  alias WebcamFornolo.Service
  alias WebcamFornolo.Mapper.MediaFileMapper

  @media_service Service.MediaFileService

  plug(:match)
  plug(WebcamFornolo.Auth)
  plug(:dispatch)

  get "/media" do
    Logger.info("get paginated media")
    page = String.to_integer(Map.get(conn.params, "page", "0"))
    rpp = String.to_integer(Map.get(conn.params, "rpp", "10"))
    media_service = Map.get(conn.assigns, :provider, @media_service)

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

  post "/media" do
    Logger.info("save media")
    media_service = Map.get(conn.assigns, :provider, @media_service)

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
    media_service = Map.get(conn.assigns, :provider, @media_service)

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
