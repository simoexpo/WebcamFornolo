defmodule WebcamfornoloBackend.Service.MediaFileService do
  alias WebcamfornoloBackend.Dal.MediaFileDao

  @media_path "media"

  def save_media(media_details) do
    IO.inspect(media_details)
    media_name = "#{UUID.uuid1()}.jpg"
    media_file_details = Map.put(media_details, :name, media_name)

    case MediaFileDao.save(media_file_details, @media_path) do
      {:ok, _} -> :ok
      _ -> :error
    end
  end

  def get_media_paginated(page, rpp) do
    MediaFileDao.get_from_path_paginated(@media_path, page, rpp)
  end
end
