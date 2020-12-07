defmodule WebcamFornolo.Auth do
  alias WebcamFornolo.Service.AuthService

  def init([]) do
    false
  end

  def call(%{method: method} = conn, _opts) do
    auth = Plug.Conn.get_req_header(conn, "authorization")

    cond do
      # TODO fix this!
      check_authorization(auth) || method == "GET" -> conn
      true -> halt_and_unauthorise_response(conn)
    end
  end

  defp token, do: Application.get_env(:webcamfornolo_backend, :authorization_token)

  defp check_authorization(["Basic " <> auth]) do
    # TODO fix this!
    auth == token() || AuthService.is_valid?(auth)
  end

  defp check_authorization(_invalid_auth), do: false

  defp halt_and_unauthorise_response(conn) do
    conn
    |> Plug.Conn.put_resp_content_type("text/plain")
    |> Plug.Conn.send_resp(401, "401 Unauthorized")
    |> Plug.Conn.halt()
  end
end
