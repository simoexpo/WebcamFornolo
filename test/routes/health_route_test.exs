defmodule WebcamFornolo.HealthRouteTest do
  use ExUnit.Case
  use Plug.Test

  alias WebcamFornolo.Routes

  @opts Routes.init([])

  test "GET /health should return 200 OK" do
    conn = :get
    |> conn("/health")
    |> Routes.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert Jason.decode!(conn.resp_body) == %{"status" => "feeling good!"}
  end
end
