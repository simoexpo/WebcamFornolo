defmodule WebcamFornolo.Cors do
  require Logger

  @origin_header "origin"
  @acao_header "access-control-allow-origin"
  @acam_header "access-control-allow-methods"
  @acah_header "access-control-allow-headers"
  @allowed_origin ["https://webcamfornolo.altervista.org"]

  defp add_cors_headers(conn, origin) do
    case Enum.member?(@allowed_origin, origin) do
      true -> conn |> Plug.Conn.put_resp_header(@acao_header, origin)
      false -> conn |> Plug.Conn.put_resp_header(@acao_header, List.first(@allowed_origin))
    end
  end

  defp send_cors_response(conn, origin) do
    conn
    |> add_cors_headers(origin)
    |> Plug.Conn.put_resp_header(@acam_header, "GET, POST, DELETE")
    |> Plug.Conn.put_resp_header(@acah_header, "authorization")
    |> Plug.Conn.send_resp(200, "")
    |> Plug.Conn.halt()
  end

  def init([]) do
    false
  end

  def call(%{method: method} = conn, _opts) do
    Logger.info("cors")
    origin = Plug.Conn.get_req_header(conn, @origin_header)

    case method do
      "OPTIONS" -> send_cors_response(conn, origin)
      _ -> add_cors_headers(conn, origin)
    end
  end
end
