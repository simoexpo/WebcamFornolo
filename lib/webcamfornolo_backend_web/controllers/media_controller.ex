defmodule WebcamfornoloBackendWeb.MediaController do
  #use WebcamfornoloBackendWeb, :controller
  alias WebcamfornoloBackendWeb.CommonController
  require Logger

  def save_media(conn, params) do
    Logger.info("save media")

    upload_result =
      Map.from_struct(params["image"])
      |> Map.put(:description, params["description"])
      #|> WebcamfornoloBackend.save_media()

    case upload_result do
      :ok ->
        conn |> CommonController.add_common_headers() #|> put_status(201)

      _ ->
        conn |> CommonController.add_common_headers() #|> put_status(500)
    end
  end

  def get_media_paginated(conn, params) do
    Logger.info("get paginated media")
    page = String.to_integer(Map.get(params, "page", "0"))
    rpp = String.to_integer(Map.get(params, "rpp", "10"))

    #case WebcamfornoloBackend.get_media_paginated(page, rpp) do
    #  {:ok, page} ->
    #    page_view = Map.update!(page, :items, fn items -> Enum.map(items, &Map.from_struct/1) end)
    #    conn |> CommonController.add_common_headers() #|> put_status(200)# |> json(page_view)

   #   _ ->
    #    conn |> CommonController.add_common_headers() #|> put_status(500)
   # end
  end

  def delete_media(conn, params) do
    id = Map.get(params, "id")
    Logger.info("delete media #{id}")

   # case WebcamfornoloBackend.delete_media(id) do
   #   :ok ->
   #     conn |> CommonController.add_common_headers() #|> put_status(204)

   #   :error ->
   #     conn |> CommonController.add_common_headers() #|> put_status(404)
    #end
  end
end
