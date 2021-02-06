defmodule WebcamFornolo.Service.Media.MediaFileServiceTest do
  use ExUnit.Case

  import WebcamFornolo.DataFixture

  alias WebcamFornolo.Service.Media.MediaFileService
  alias WebcamFornolo.DaoFixtures.DummyMediaFileDao

  test "MediaFileService should save an image media file" do
    media = a_media_file("image")
    assert MediaFileService.save_media(media, DummyMediaFileDao.SuccessImpl) == :ok
  end

  test "MediaFileService should save a video media file" do
    media = a_media_file("video")
    assert MediaFileService.save_media(media, DummyMediaFileDao.SuccessImpl) == :ok
  end

  test "MediaFileService should return an error if the media file content type is unknown" do
    media = a_media_file("unknown")
    assert MediaFileService.save_media(media, DummyMediaFileDao.ErrorImpl) == :error
  end

  test "MediaFileService should return an error if fail to save a media file" do
    media = a_media_file()
    assert MediaFileService.save_media(media, DummyMediaFileDao.ErrorImpl) == :error
  end

  test "MediaFileService should return a list of media file paginated" do
    {:ok, %{total_pages: n, items: result}} =
      MediaFileService.get_media_paginated(1, 10, DummyMediaFileDao.SuccessImpl)

    assert is_list(result) == true
  end

  test "MediaFileService should return an error if fail to get a list of media file paginated" do
    assert MediaFileService.get_media_paginated(1, 10, DummyMediaFileDao.ErrorImpl) == :error
  end

  test "MediaFileService should delete a media" do
    assert MediaFileService.delete_media("media_id", DummyMediaFileDao.SuccessImpl) == :ok
  end

  test "MediaFileService should return an error if fail to delete a media" do
    assert MediaFileService.delete_media("media_id", DummyMediaFileDao.ErrorImpl) == :error
  end
end
