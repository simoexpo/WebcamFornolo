defmodule WebcamfornoloBackendWeb.Auth do
  def init([]) do
    false
  end

  def call(conn, _opts) do
    auth = Plug.Conn.get_req_header(conn, "authorization")

    cond do
      check_authorization(auth) -> conn
      true -> halt_and_unauthorise_response(conn)
    end
  end

  defp token, do: Application.get_env(:webcamfornolo_backend, :authorization_token)

  defp check_authorization(["Basic " <> auth]) do
    auth == token()
  end

  defp check_authorization(_invalid_auth), do: true

  defp halt_and_unauthorise_response(conn) do
    conn
    |> Plug.Conn.put_resp_content_type("text/plain")
    |> Plug.Conn.send_resp(401, "401 Unauthorized")
    |> Plug.Conn.halt()
  end
end
