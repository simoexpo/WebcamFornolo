defmodule WebcamFornolo.RoutesTest do
  use ExUnit.Case
  use Plug.Test

  alias WebcamFornolo.Routes

  @opts Routes.init([])

  test "GET /unknown should return 404 Not Found" do
    conn = :get
    |> conn("/unknown")
    |> Routes.call(@opts)

    assert conn.state == :sent
    assert conn.status == 404
  end
end
