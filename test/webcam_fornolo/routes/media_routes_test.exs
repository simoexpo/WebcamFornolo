defmodule WebcamFornolo.Routes.MediaRoutesTest do
  use ExUnit.Case
  use Plug.Test

  alias WebcamFornolo.Routes
  alias WebcamFornolo.ServiceFixtures.DummyMediaService
  alias WebcamFornolo.ServiceFixtures.DummyAuthService

  @dummy_authentication [authentication_provider: DummyAuthService]
  @dummy_succes_opts Routes.init(@dummy_authentication ++ [media_provider: DummyMediaService.SuccessImpl])
  @dummy_error_opts Routes.init(@dummy_authentication ++ [media_provider: DummyMediaService.ErrorImpl])
  @dummy_invalid_id_opts Routes.init(@dummy_authentication ++ [media_provider: DummyMediaService.InvalidIdImpl])
  @webcam_image_test "test/resources/webcam_image_test.jpg"
  @webcam_image_test_filename "webcam_image_test.jpg"
  @content_type "image/png"

  test "GET /api/media should return 200 OK with media list" do
    conn =
      :get
      |> conn("/api/media")
      |> Routes.call(@dummy_succes_opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert Jason.decode!(conn.resp_body) == %{"total_pages" => 11, "items" => []}
  end

  test "GET /api/media should return 500 Internal Server Error in case of unexpected error" do
    conn =
      :get
      |> conn("/api/media")
      |> Routes.call(@dummy_error_opts)

    assert conn.state == :sent
    assert conn.status == 500
  end

  test "POST /api/media should return 201 Created" do
    conn =
      :post
      |> conn("/api/media", %{image: webcam_image_to_upload()})
      |> put_req_header("authorization", "Bearer token")
      |> Routes.call(@dummy_succes_opts)

    assert conn.state == :sent
    assert conn.status == 201
  end

  test "POST /api/media should return 401 Unauthorized in case of missing token" do
    conn =
      :post
      |> conn("/api/media", %{image: webcam_image_to_upload()})
      |> Routes.call(@dummy_succes_opts)

    assert conn.state == :sent
    assert conn.status == 401
  end

  test "POST /api/media should return 401 Unauthorized in case of invalid token" do
    conn =
      :post
      |> conn("/api/media", %{image: webcam_image_to_upload()})
      |> put_req_header("authorization", "Bearer invalid")
      |> Routes.call(@dummy_succes_opts)

    assert conn.state == :sent
    assert conn.status == 401
  end

  test "POST /api/media should return 500 Internal Server Error" do
    conn =
      :post
      |> conn("/api/media", %{image: webcam_image_to_upload()})
      |> put_req_header("authorization", "Bearer token")
      |> Routes.call(@dummy_error_opts)

    assert conn.state == :sent
    assert conn.status == 500
  end

  test "DELETE /api/media/id should return 204 No Content id the id is valid" do
    conn =
      :delete
      |> conn("/api/media/id")
      |> put_req_header("authorization", "Bearer token")
      |> Routes.call(@dummy_succes_opts)

    assert conn.state == :sent
    assert conn.status == 204
  end

  test "DELETE /api/media/id should return 401 Unauthorized in case of missing token" do
    conn =
      :delete
      |> conn("/api/media/id")
      |> Routes.call(@dummy_succes_opts)

    assert conn.state == :sent
    assert conn.status == 401
  end

  test "DELETE /api/media/id should return 401 Unauthorized in case of invalid token" do
    conn =
      :delete
      |> conn("/api/media/id")
      |> put_req_header("authorization", "Bearer invalid")
      |> Routes.call(@dummy_succes_opts)

    assert conn.state == :sent
    assert conn.status == 401
  end

  test "DELETE /api/media/id should return 404 Not Found if the id is not valid" do
    conn =
      :delete
      |> conn("/api/media/id")
      |> put_req_header("authorization", "Bearer token")
      |> Routes.call(@dummy_invalid_id_opts)

    assert conn.state == :sent
    assert conn.status == 404
  end

  test "DELETE /api/media/id should return 500 Internal Server Error in case of unexpected error" do
    conn =
      :delete
      |> conn("/api/media/id")
      |> put_req_header("authorization", "Bearer token")
      |> Routes.call(@dummy_error_opts)

    assert conn.state == :sent
    assert conn.status == 500
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
