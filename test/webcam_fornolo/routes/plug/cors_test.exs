defmodule WebcamFornolo.Routes.Plug.CorsTest do
  use ExUnit.Case
  use Plug.Test

  alias WebcamFornolo.Routes.Plug.Cors

  @origin_header "origin"
  @acao_header "access-control-allow-origin"
  @acam_header "access-control-allow-methods"
  @acah_header "access-control-allow-headers"
  @valid_origin "https://www.webcamfornolo.org"
  @default_origin "https://webcamfornolo.org"
  @supported_method "GET, POST, DELETE"
  @supported_header "authorization"
  @opts []

  test "Cors plug should add cors header and reply to OPTIONS request" do
    conn =
      :options
      |> conn("/an/api/path")
      |> put_req_header(@origin_header, @valid_origin)
      |> Cors.call(@opts)

    assert conn.status == 200
    assert get_resp_header(conn, @acao_header) == [@valid_origin]
    assert get_resp_header(conn, @acam_header) == [@supported_method]
    assert get_resp_header(conn, @acah_header) == [@supported_header]
  end

  test "Cors plug should add access-control-allow-origin header if origin is valid" do
    conn =
      :get
      |> conn("/an/api/path")
      |> put_req_header(@origin_header, @valid_origin)
      |> Cors.call(@opts)

    assert conn.halted == false
    assert get_resp_header(conn, @acao_header) == [@valid_origin]
  end

  test "Cors plug should add dafault access-control-allow-origin header if origin is not valid" do
    conn =
      :get
      |> conn("/an/api/path")
      |> put_req_header(@origin_header, "invalid")
      |> Cors.call(@opts)

    assert conn.halted == false
    assert get_resp_header(conn, @acao_header) == [@default_origin]
  end
end
