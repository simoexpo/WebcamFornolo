defmodule WebcamfornoloBackendWeb.MediaController do
  use WebcamfornoloBackendWeb, :controller
  require Logger

  @acao_header "Access-Control-Allow-Origin"
  @allowed_origin "https://webcamfornolo.altervista.org"

  def save_media(conn, params) do
    Logger.info("save media")

    upload_result =
      Map.from_struct(params["image"])
      |> Map.put(:description, params["descr"])
      |> WebcamfornoloBackend.save_media()

    # check the name

    case upload_result do
      :ok ->
        conn |> put_resp_header(@acao_header, @allowed_origin) |> put_status(200) |> json(%{})

      _ ->
        conn |> put_resp_header(@acao_header, @allowed_origin) |> put_status(500) |> json(%{})
    end
  end

  def get_media_paginated(conn, params) do
    Logger.info("get media")
    conn |> put_status(200) |> json(%{})
  end
end
