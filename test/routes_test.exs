defmodule WebcamFornolo.RoutesTest do
  use ExUnit.Case
  use Plug.Test

  alias WebcamFornolo.Routes

  @opts Routes.init([])

  test "GET /index.html should return the static resource" do
    conn =
      :get
      |> conn("/index.html")
      |> Routes.call(@opts)

    assert conn.state == :file
    assert conn.status == 200
  end

  test "GET / should redirect to index.html the static resource" do
    conn =
      :get
      |> conn("/")
      |> Routes.call(@opts)

    assert conn.state == :set
    assert conn.status == 302
  end

  test "GET /img/[resource] should return the static resource" do
    conn =
      :get
      |> conn("/img/snow-bg-3840.jpg")
      |> Routes.call(@opts)

    assert conn.state == :file
    assert conn.status == 200
  end

  test "GET /css/[resource] should return the static resource" do
    conn =
      :get
      |> conn("/css/webcam-fornolo.css")
      |> Routes.call(@opts)

    assert conn.state == :file
    assert conn.status == 200
  end

  test "GET /js/[resource] should return the static resource" do
    conn =
      :get
      |> conn("/js/webcam-fornolo.js")
      |> Routes.call(@opts)

    assert conn.state == :file
    assert conn.status == 200
  end

  test "GET /unknown should return 404 Not Found" do
    conn =
      :get
      |> conn("/unknown")
      |> Routes.call(@opts)

    assert conn.state == :sent
    assert conn.status == 404
  end

  test "GET /api/unknown should return 404 Not Found" do
    conn =
      :get
      |> conn("/api/unknown")
      |> Routes.call(@opts)

    assert conn.state == :sent
    assert conn.status == 404
  end
end
