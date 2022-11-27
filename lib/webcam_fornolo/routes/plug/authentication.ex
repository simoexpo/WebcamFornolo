defmodule WebcamFornolo.Routes.Plug.Authentication do
  import Plug.Conn

  require Logger

  alias WebcamFornolo.Service.Authentication.CacheAuthService

  @auth_provider_key :authentication_provider
  @default_auth_provider CacheAuthService
  @authorization_header "authorization"

  defp master_token, do: Application.get_env(:webcam_fornolo, :authorization_token)

  @spec validate_token(Plug.Conn.t(), any) :: Plug.Conn.t()
  def validate_token(conn, _opts) do
    provider = get_auth_provider(conn)
    auth = get_req_header(conn, @authorization_header)

    if token_is_valid(provider, auth) do
      conn
    else
      halt_and_unauthorise_response(conn)
    end
  end

  defp token_is_valid(provider, ["Bearer " <> auth]) do
    # TODO fix this!
    provider.is_valid?(auth) || auth == master_token
  end

  defp token_is_valid(_provider, _invalid_auth), do: false

  defp halt_and_unauthorise_response(conn) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(401, "")
    |> halt()
  end

  defp get_auth_provider(conn) do
    Map.get(conn.assigns, @auth_provider_key, @default_auth_provider)
  end
end
