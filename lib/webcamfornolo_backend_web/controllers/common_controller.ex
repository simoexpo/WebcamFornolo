defmodule WebcamfornoloBackendWeb.CommonController do
 # use WebcamfornoloBackendWeb, :controller

  @acao_header "Access-Control-Allow-Origin"
  @acam_header "Access-Control-Allow-Methods"
  @acah_header "Access-Control-Allow-Headers"
  @allowed_origin "https://webcamfornolo.altervista.org"

  def add_common_headers(conn) do
    conn #|> put_resp_header(@acao_header, @allowed_origin)
  end

  def options(conn, _params) do
    conn
    #|> add_common_headers
    #|> put_resp_header(@acam_header, "GET, POST, DELETE")
    #|> put_resp_header(@acah_header, "Authorization")
    #|> put_status(200)
    #|> json(%{})
  end
end
