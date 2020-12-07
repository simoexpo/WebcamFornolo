defmodule WebcamFornolo.Route.AuthRoute do
  use Plug.Router

  require Logger

  alias WebcamFornolo.Service.AuthService

  plug(:match)
  plug(:dispatch)

  post "/login" do
    Logger.info("Logging in...")
    password = Map.get(conn.params, "password")

    with {:ok, token} <- AuthService.authenticate(password) do
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
    ["Basic " <> auth] = Plug.Conn.get_req_header(conn, "authorization")
    AuthService.invalidate(auth)
    send_resp(conn, 200, "")
  end
end
