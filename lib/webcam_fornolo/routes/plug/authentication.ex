defmodule WebcamFornolo.Routes.Plug.Authentication do
  import Plug.Conn

  require Logger

  alias WebcamFornolo.Service.CacheAuthService

  @provider_key :authentication_provider
  @default_auth_provider CacheAuthService
  @authorization_header "authorization"

  @spec validate_token(Plug.Conn.t(), any) :: Plug.Conn.t()
  def validate_token(%{method: method} = conn, _opts) do
    provider = Map.get(conn.assigns, @provider_key, @default_auth_provider)
    auth = get_req_header(conn, @authorization_header)

    cond do
      # TODO fix this!
      check_authorization(provider, auth) || method == "GET" -> conn
      true -> halt_and_unauthorise_response(conn)
    end
  end

  defp token, do: Application.get_env(:webcam_fornolo, :authorization_token)

  defp check_authorization(provider, ["Bearer " <> auth]) do
    # TODO fix this!
    provider.is_valid?(auth) || auth == token()
  end

  defp check_authorization(_provider, _invalid_auth), do: false

  defp halt_and_unauthorise_response(conn) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(401, "401 Unauthorized")
    |> halt()
  end
end
