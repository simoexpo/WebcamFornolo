defmodule WebcamFornolo.Routes.WebcamRoutesTest do
  use ExUnit.Case
  use Plug.Test

  alias WebcamFornolo.Routes
  alias WebcamFornolo.ServiceFixtures.DummyWebcamService
  alias WebcamFornolo.ServiceFixtures.DummyAuthService

  @authentication_provider [authentication_provider: DummyAuthService]
  @success_opts Routes.init(@authentication_provider ++ [webcam_provider: DummyWebcamService.SuccessImpl])
  @error_opts Routes.init(@authentication_provider ++ [webcam_provider: DummyWebcamService.ErrorImpl])
  @not_found_opts Routes.init(@authentication_provider ++ [webcam_provider: DummyWebcamService.InvalidIdImpl])
  @webcam_image_test "test/resources/webcam_image_test.jpg"
  @webcam_image_test_filename "webcam_image_test.jpg"
  @content_type "image/png"

  test "GET /api/webcam/id should return 200 OK with webcam image if the id is valid" do
    conn =
      :get
      |> conn("/api/webcam/id")
      |> Routes.call(@success_opts)

    assert conn.state == :file
    assert conn.status == 200
    assert conn.resp_body == webcam_image_test_content()
  end

  test "GET /api/webcam/id should return 404 Not Found id the id is not valid" do
    conn =
      :get
      |> conn("/api/webcam/id")
      |> Routes.call(@not_found_opts)

    assert conn.state == :sent
    assert conn.status == 404
  end

  test "GET /api/webcam/id should return 500 Internal Server Error in case of unexpected error" do
    conn =
      :get
      |> conn("/api/webcam/id")
      |> Routes.call(@error_opts)

    assert conn.state == :sent
    assert conn.status == 500
  end

  test "POST /api/webcam/id should return 201 Created if the id is valid" do
    conn =
      :post
      |> conn("/api/webcam/id", %{image: webcam_image_to_upload()})
      |> put_req_header("authorization", "Bearer token")
      |> Routes.call(@success_opts)

    assert conn.state == :sent
    assert conn.status == 201
  end

  test "POST /api/webcam/id should return 401 Unauthorized if the id is valid in case of invalid authentication" do
    conn =
      :post
      |> conn("/api/webcam/id", %{image: webcam_image_to_upload()})
      |> put_req_header("authorization", "Bearer invalid")
      |> Routes.call(@success_opts)

    assert conn.state == :sent
    assert conn.status == 401
  end

  test "POST /api/webcam/id should return 401 Unauthorized if the id is valid in case of missing authentication" do
    conn =
      :post
      |> conn("/api/webcam/id", %{image: webcam_image_to_upload()})
      |> Routes.call(@success_opts)

    assert conn.state == :sent
    assert conn.status == 401
  end

  test "POST /api/webcam/id should return 404 Not Found if the id is not valid" do
    conn =
      :post
      |> conn("/api/webcam/id", %{image: webcam_image_to_upload()})
      |> put_req_header("authorization", "Bearer token")
      |> Routes.call(@not_found_opts)

    assert conn.state == :sent
    assert conn.status == 404
  end

  test "POST /api/webcam/id should return 500 Internal Server Error" do
    conn =
      :post
      |> conn("/api/webcam/id", %{image: webcam_image_to_upload()})
      |> put_req_header("authorization", "Bearer token")
      |> Routes.call(@error_opts)

    assert conn.state == :sent
    assert conn.status == 500
  end

  test "POST /api/webcam/id/reset should return 201 Created if the id is valid" do
    conn =
      :post
      |> conn("/api/webcam/id/reset")
      |> put_req_header("authorization", "Bearer token")
      |> Routes.call(@success_opts)

    assert conn.state == :sent
    assert conn.status == 200
  end

  test "POST /api/webcam/id/reset should return 401 Unauthorized if the id is valid in case of invalid authentication" do
    conn =
      :post
      |> conn("/api/webcam/id/reset")
      |> put_req_header("authorization", "Bearer invalid")
      |> Routes.call(@success_opts)

    assert conn.state == :sent
    assert conn.status == 401
  end

  test "POST /api/webcam/id/reset should return 401 Unauthorized if the id is valid in case of missing authentication" do
    conn =
      :post
      |> conn("/api/webcam/id/reset")
      |> Routes.call(@success_opts)

    assert conn.state == :sent
    assert conn.status == 401
  end

  test "POST /api/webcam/id/reset should return 404 Not Found if the id is not valid" do
    conn =
      :post
      |> conn("/api/webcam/id/reset")
      |> put_req_header("authorization", "Bearer token")
      |> Routes.call(@not_found_opts)

    assert conn.state == :sent
    assert conn.status == 404
  end

  test "POST /api/webcam/id/reset should return 500 Internal Server Error" do
    conn =
      :post
      |> conn("/api/webcam/id/reset")
      |> put_req_header("authorization", "Bearer token")
      |> Routes.call(@error_opts)

    assert conn.state == :sent
    assert conn.status == 500
  end

  test "GET /api/webcam/id/unknown should return 404 Not Found" do
    conn =
      :get
      |> conn("/api/webcam/id/unknown")
      |> put_req_header("authorization", "Bearer token")
      |> Routes.call(@success_opts)

    assert conn.state == :sent
    assert conn.status == 404
  end

  def webcam_image_test_path(), do: @webcam_image_test
  defp webcam_image_test_content(), do: File.read!(@webcam_image_test)

  defp webcam_image_to_upload(),
    do: %Plug.Upload{
      path: @webcam_image_test,
      filename: @webcam_image_test_filename,
      content_type: @content_type
    }
end
