defmodule WebcamFornolo.Service.Media.WebcamImageServiceTest do
  use ExUnit.Case

  import WebcamFornolo.DataFixture

  alias WebcamFornolo.Service.Media.WebcamImageService
  alias WebcamFornolo.DaoFixtures.DummyMediaFileDao
  alias WebcamFornolo.ServiceFixtures.DummyImageEditorService

  test "WebcamImageService should return a webcam image url" do
    {:ok, url} = WebcamImageService.get_webcam("1", DummyMediaFileDao.SuccessImpl)
    assert is_binary(url) == true
  end

  # test "WebcamImageService should return an error if the webcam id to retrieve is not valid" do
  #   assert WebcamImageService.get_webcam("invalid", DummyMediaFileDao.SuccessImpl) == :error
  # end

  test "WebcamImageService should return an error if fail to retrieve a webcam image" do
    assert WebcamImageService.get_webcam("1", DummyMediaFileDao.ErrorImpl) == :error
  end

  test "WebcamImageService should save a webcam image" do
    media = a_media_file("image")

    assert WebcamImageService.save_webcam(
             "1",
             media,
             DummyMediaFileDao.SuccessImpl,
             DummyImageEditorService.SuccessImpl
           ) == :ok
  end

  # test "WebcamImageService should return an error if the webcam id to save is not valid" do
  #   media = a_media_file("image")

  #   assert WebcamImageService.save_webcam(
  #            "invalid",
  #            media,
  #            DummyMediaFileDao.SuccessImpl,
  #            DummyImageEditorService.SuccessImpl
  #          ) == :error
  # end

  # test "WebcamImageService should return an error if fail to edit the image" do
  #   media = a_media_file("image")

  #   assert WebcamImageService.save_webcam(
  #            "invalid",
  #            media,
  #            DummyMediaFileDao.SuccessImpl,
  #            DummyImageEditorService.ErrorImpl
  #          ) == :error
  # end

  test "WebcamImageService should return an error if fail to save a webcam image" do
    media = a_media_file("image")

    assert WebcamImageService.save_webcam(
             "1",
             media,
             DummyMediaFileDao.ErrorImpl,
             DummyImageEditorService.SuccessImpl
           ) ==
             :error
  end
end
