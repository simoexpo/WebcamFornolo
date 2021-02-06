defmodule WebcamFornolo.Routes.AuthRoute do
  use Plug.Router

  require Logger

  alias WebcamFornolo.Service.CacheAuthService

  @auth_provider_key :authentication_provider
  @default_auth_provider CacheAuthService

  plug(:match)
  plug(:dispatch)

  post "/login" do
    Logger.info("Logging in...")
    password = Map.get(conn.params, "password")
    provider = get_auth_provider(conn)

    with {:ok, token} <- provider.authenticate(password) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{"token" => token}))
    else
      _ ->
        conn
        |> send_resp(401, "")
    end
  end

  post "/logout" do
    Logger.info("Logging out...")
    provider = get_auth_provider(conn)
    ["Bearer " <> auth] = Plug.Conn.get_req_header(conn, "authorization")
    provider.invalidate(auth)
    send_resp(conn, 200, "")
  end

  defp get_auth_provider(conn) do
    Map.get(conn.assigns, @auth_provider_key, @default_auth_provider)
  end
end
