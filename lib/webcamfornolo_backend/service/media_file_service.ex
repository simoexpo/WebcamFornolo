defmodule WebcamfornoloBackend.Service.MediaFileService do
  alias WebcamfornoloBackend.Dal.MediaFileDao

  @media_path "media"

  def save_media(media_details) do
    IO.inspect(media_details)

    case MediaFileDao.save(media_details, @media_path) do
      {:ok, _} -> :ok
      _ -> :error
    end
  end
end
