defmodule WebcamFornolo.Route.HealthRoute do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/health" do
    send_resp(conn, 200, Jason.encode!(%{"status" => "feeling good!"}))
  end
end
