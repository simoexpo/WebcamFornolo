defmodule WebcamFornolo.Service.Media.WebcamServiceTest do
  use ExUnit.Case

  import WebcamFornolo.DataFixture

  alias WebcamFornolo.Service.Media.WebcamService
  alias WebcamFornolo.DaoFixtures.DummyMediaFileDao
  alias WebcamFornolo.ServiceFixtures.DummyImageEditorService

  test "WebcamService should return a webcam image url" do
    {:ok, url} = WebcamService.get_media("1", DummyMediaFileDao.SuccessImpl)
    assert is_binary(url) == true
  end

  # test "WebcamService should return an error if the webcam id to retrieve is not valid" do
  #   assert WebcamService.get_media("invalid", DummyMediaFileDao.SuccessImpl) == :error
  # end

  test "WebcamService should return an error if fail to retrieve a webcam image" do
    assert WebcamService.get_media("1", DummyMediaFileDao.ErrorImpl) == :error
  end

  test "WebcamService should save a webcam image" do
    media = a_media_file("image")

    assert WebcamService.capture_photo(
             "1",
             media,
             DummyMediaFileDao.SuccessImpl,
             DummyImageEditorService.SuccessImpl
           ) == :ok
  end

  # test "WebcamService should return an error if the webcam id to save is not valid" do
  #   media = a_media_file("image")

  #   assert WebcamService.capture_photo(
  #            "invalid",
  #            media,
  #            DummyMediaFileDao.SuccessImpl,
  #            DummyImageEditorService.SuccessImpl
  #          ) == :error
  # end

  # test "WebcamService should return an error if fail to edit the image" do
  #   media = a_media_file("image")

  #   assert WebcamService.capture_photo(
  #            "invalid",
  #            media,
  #            DummyMediaFileDao.SuccessImpl,
  #            DummyImageEditorService.ErrorImpl
  #          ) == :error
  # end

  test "WebcamService should return an error if fail to save a webcam image" do
    media = a_media_file("image")

    assert WebcamService.capture_photo(
             "1",
             media,
             DummyMediaFileDao.ErrorImpl,
             DummyImageEditorService.SuccessImpl
           ) ==
             :error
  end
end
