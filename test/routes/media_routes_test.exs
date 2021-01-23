defmodule WebcamFornolo.MediaRoutesTest do
  use ExUnit.Case
  use Plug.Test

  alias WebcamFornolo.Routes
  alias WebcamFornolo.MediaRoutesTest.FakeMediaService

  @opts Routes.init([])
  @webcam_image_test "test/resources/webcam_image_test.jpg"
  @webcam_image_test_filename "webcam_image_test.jpg"
  @content_type "image/png"

  test "GET /api/media should return 200 OK with media list" do
    conn =
      :get
      |> conn("/api/media")
      |> assign(:provider, FakeMediaService.SuccessImpl)
      |> Routes.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert Jason.decode!(conn.resp_body) == %{"total_pages" => 11, "items" => []}
  end

  test "GET /api/media should return 500 Internal Server Error in case of unexpected error" do
    conn =
      :get
      |> conn("/api/media")
      |> assign(:provider, FakeMediaService.ErrorImpl)
      |> Routes.call(@opts)

    assert conn.state == :sent
    assert conn.status == 500
  end

  test "POST /api/media should return 201 Created" do
    conn =
      :post
      |> conn("/api/media", %{image: webcam_image_to_upload()})
      |> assign(:provider, FakeMediaService.SuccessImpl)
      |> put_req_header("authorization", "Bearer token")
      |> Routes.call(@opts)

    assert conn.state == :sent
    assert conn.status == 201
  end

  test "POST /api/media should return 401 Forbidden in case of invalid authentication" do
    conn =
      :post
      |> conn("/api/media", %{image: webcam_image_to_upload()})
      |> assign(:provider, FakeMediaService.SuccessImpl)
      |> Routes.call(@opts)

    assert conn.state == :sent
    assert conn.status == 401
  end

  test "POST /api/media should return 500 Internal Server Error" do
    conn =
      :post
      |> conn("/api/media", %{image: webcam_image_to_upload()})
      |> assign(:provider, FakeMediaService.ErrorImpl)
      |> put_req_header("authorization", "Bearer token")
      |> Routes.call(@opts)

    assert conn.state == :sent
    assert conn.status == 500
  end

  test "DELETE /api/media/id should return 204 No Content id the id is valid" do
    conn =
      :delete
      |> conn("/api/media/id")
      |> assign(:provider, FakeMediaService.SuccessImpl)
      |> put_req_header("authorization", "Bearer token")
      |> Routes.call(@opts)

    assert conn.state == :sent
    assert conn.status == 204
  end

  test "DELETE /api/media/id should return 401 Forbidden in case of invalid authenticatio" do
    conn =
      :delete
      |> conn("/api/media/id")
      |> assign(:provider, FakeMediaService.SuccessImpl)
      |> Routes.call(@opts)

    assert conn.state == :sent
    assert conn.status == 401
  end

  test "DELETE /api/media/id should return 404 Not Found id the id is not valid" do
    conn =
      :delete
      |> conn("/api/media/id")
      |> assign(:provider, FakeMediaService.InvalidIdImpl)
      |> put_req_header("authorization", "Bearer token")
      |> Routes.call(@opts)

    assert conn.state == :sent
    assert conn.status == 404
  end

  test "DELETE /api/media/id should return 500 Internal Server Error in case of unexpected error" do
    conn =
      :delete
      |> conn("/api/media/id")
      |> assign(:provider, FakeMediaService.ErrorImpl)
      |> put_req_header("authorization", "Bearer token")
      |> Routes.call(@opts)

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

  defmodule FakeMediaService do
    defmodule SuccessImpl do
      def get_media_paginated(_page, _rpp), do: {:ok, %{total_pages: 11, items: []}}
      def save_media(_media), do: :ok
      def delete_media(_id), do: :ok
    end

    defmodule InvalidIdImpl do
      def delete_media(_id), do: :notfound
    end

    defmodule ErrorImpl do
      def get_media_paginated(_page, _rpp), do: :error
      def save_media(_media), do: :error
      def delete_media(_id), do: :error
    end
  end
end
