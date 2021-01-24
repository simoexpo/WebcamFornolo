defmodule WebcamFornolo.Routes.AuthRouteTest do
  use ExUnit.Case
  use Plug.Test

  alias WebcamFornolo.Routes
  alias WebcamFornolo.ServiceFixtures.DummyAuthService

  @opts Routes.init(authentication_provider: DummyAuthService)

  test "POST /api/login should return 200 OK and a valid token in case of valid password" do
    conn =
      :post
      |> conn("/api/login", %{password: DummyAuthService.valid_password()})
      |> Routes.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert Jason.decode!(conn.resp_body) == %{"token" => DummyAuthService.valid_token()}
  end

  test "POST /api/login should return 401 Unauthorized in case of invalid password" do
    conn =
      :post
      |> conn("/api/login", %{password: "invalid"})
      |> Routes.call(@opts)

    assert conn.state == :sent
    assert conn.status == 401
  end

  test "POST /api/logout should return 200 OK" do
    conn =
      :post
      |> conn("/api/logout")
      |> put_req_header("authorization", "Bearer #{DummyAuthService.valid_token()}")
      |> Routes.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
  end
end
