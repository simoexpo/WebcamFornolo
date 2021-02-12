defmodule WebcamFornolo.Routes.Plug.AuthenticationTest do
  use ExUnit.Case
  use Plug.Test

  import WebcamFornolo.Routes.Plug.Authentication, only: [validate_token: 2]

  alias WebcamFornolo.ServiceFixtures.DummyAuthService

  @opts []

  test "Authentication plug should validate a token" do
    conn =
      :post
      |> conn("/an/api/path")
      |> put_req_header("authorization", "Bearer #{DummyAuthService.valid_token()}")
      |> assign(:authentication_provider, DummyAuthService)
      |> validate_token(@opts)

    assert conn.halted == false
  end

  test "Authentication plug should reject an invalid token" do
    conn =
      :post
      |> conn("/an/api/path")
      |> put_req_header("authorization", "Bearer invalid")
      |> assign(:authentication_provider, DummyAuthService)
      |> validate_token(@opts)

    assert conn.state == :sent
    assert conn.status == 401
    assert conn.halted == true
  end

  test "Authentication plug should reject missing token" do
    conn =
      :post
      |> conn("/an/api/path")
      |> assign(:authentication_provider, DummyAuthService)
      |> validate_token(@opts)

    assert conn.state == :sent
    assert conn.status == 401
    assert conn.halted == true
  end
end
