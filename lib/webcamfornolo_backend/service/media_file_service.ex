defmodule WebcamfornoloBackend.Service.MediaFileService do
  alias WebcamfornoloBackend.Dal.Altervista.AltervistaDal
  alias WebcamfornoloBackend.Dal.MediaFileDao

  def save_media(media_details) do
    IO.inspect(media_details)
    case AltervistaDal.save_file(media_details, "webcam") do
      :ok -> :ok
      {:ok, path} -> :ok #MediaFileDao.save()
      :error -> :error
    end

  end
end
