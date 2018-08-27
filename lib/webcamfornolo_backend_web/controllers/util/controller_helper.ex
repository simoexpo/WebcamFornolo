defmodule WebcamfornoloBackendWeb.Util.ControllerHelper do
  import Plug.Conn

  @acao_header "Access-Control-Allow-Origin"
  @allowed_origin "https://webcamfornolo.altervista.org"

  def add_common_headers(conn) do
    conn |> put_resp_header(@acao_header, @allowed_origin)
  end
end
