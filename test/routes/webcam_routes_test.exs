defmodule WebcamFornolo.WebcamRoutesTest do
  use ExUnit.Case
  use Plug.Test

  alias WebcamFornolo.Routes
  alias WebcamFornolo.WebcamRoutesTest.FakeWebcamService

  @opts Routes.init([])
  @webcam_image_test "test/resources/webcam_image_test.jpg"
  @webcam_image_test_filename "webcam_image_test.jpg"
  @content_type "image/png"


  test "GET /webcam/id should return 200 OK with webcam image if the id is valid" do
    conn = :get
    |> conn("/webcam/id")
    |> assign(:provider, FakeWebcamService.SuccessImpl)
    |> Routes.call(@opts)

    assert conn.state == :file
    assert conn.status == 200
    assert conn.resp_body == webcam_image_test_content()
  end

  test "GET /webcam/id should return 404 Not Found id the id is not valid" do
    conn = :get
    |> conn("/webcam/id")
    |> assign(:provider, FakeWebcamService.InvalidIdImpl)
    |> Routes.call(@opts)

    assert conn.state == :sent
    assert conn.status == 404
  end

  test "GET /webcam/id should return 500 Internal Server Error in case of unexpected error" do
    conn = :get
    |> conn("/webcam/id")
    |> assign(:provider, FakeWebcamService.ErrorImpl)
    |> Routes.call(@opts)

    assert conn.state == :sent
    assert conn.status == 500
  end

  test "POST /webcam/id should return 201 Created if the id is valid" do
    conn = :post
    |> conn("/webcam/id", %{image: webcam_image_to_upload()})
    |> assign(:provider, FakeWebcamService.SuccessImpl)
    |> Routes.call(@opts)

    assert conn.state == :sent
    assert conn.status == 201
  end

  test "POST /webcam/id should return 404 Not Found if the id is not valid" do
    conn = :post
    |> conn("/webcam/id", %{image: webcam_image_to_upload()})
    |> assign(:provider, FakeWebcamService.InvalidIdImpl)
    |> Routes.call(@opts)

    assert conn.state == :sent
    assert conn.status == 404
  end

  test "POST /webcam/id should return 500 Internal Server Error" do
    conn = :post
    |> conn("/webcam/id", %{image: webcam_image_to_upload()})
    |> assign(:provider, FakeWebcamService.ErrorImpl)
    |> Routes.call(@opts)

    assert conn.state == :sent
    assert conn.status == 500
  end


  def webcam_image_test_path(), do: @webcam_image_test
  defp webcam_image_test_content(), do: File.read!(@webcam_image_test)
  defp webcam_image_to_upload(), do: %Plug.Upload{
    path: @webcam_image_test,
    filename: @webcam_image_test_filename,
    content_type: @content_type
  }

  defmodule FakeWebcamService do
    defmodule SuccessImpl do
      def get_webcam(_id), do: {:ok, WebcamFornolo.WebcamRoutesTest.webcam_image_test_path()}
      def save_webcam(_id, _webcam_image), do: :ok
    end
    defmodule InvalidIdImpl do
      def get_webcam(_id), do: :notfound
      def save_webcam(_id, _webcam_image), do: :notfound
    end
    defmodule ErrorImpl do
      def get_webcam(_id), do: :error
      def save_webcam(_id, _webcam_image), do: :error
    end
  end
end
