defmodule WebcamFornolo.Routes.Plug.Cors do
  require Logger

  @origin_header "origin"
  @acao_header "access-control-allow-origin"
  @acam_header "access-control-allow-methods"
  @acah_header "access-control-allow-headers"
  @allowed_origin [
    "https://webcamfornolo.org",
    "https://www.webcamfornolo.org",
    "https://webcamfornolo.altervista.org",
    "http://localhost:4000"
  ]

  @spec init([]) :: false
  def init([]) do
    false
  end

  @spec call(Plug.Conn.t(), any) :: Plug.Conn.t()
  def call(conn = %{method: method}, _opts) do
    origin = Plug.Conn.get_req_header(conn, @origin_header) |> List.first()
    Logger.info("Check cors from origin #{origin}")

    case method do
      "OPTIONS" -> send_cors_response(conn, origin)
      _ -> add_cors_headers(conn, origin)
    end
  end

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
end
