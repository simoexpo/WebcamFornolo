defmodule WebcamfornoloBackendWeb.MediaController do
  use WebcamfornoloBackendWeb, :controller
  require Logger

  def save_media(conn, params) do
    Logger.info("save media")

    asd = Map.from_struct(params["image"])
    |> WebcamfornoloBackend.save_media()

    case asd do
      :ok -> conn |> put_status(200) |> json(%{})
      _ -> conn |> put_status(500) |> json(%{})
    end
  end

  def get_media_paginated(conn, params) do
    Logger.info("get media")
    conn |> put_status(200) |> json(%{})
  end
end
