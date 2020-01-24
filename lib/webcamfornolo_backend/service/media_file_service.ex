defmodule WebcamFornolo.Service.MediaFileService do

  alias WebcamFornolo.Dal.MediaFileDao
  alias WebcamFornolo.Model.MediaFile

  @media_path "media"

  def save_media(media_details) do
    IO.inspect(media_details)

    case get_media_name(media_details) do
      {:ok, media_name} ->
        media_file_details = Map.put(media_details, :name, media_name)

        case MediaFileDao.save(media_file_details, @media_path) do
          {:ok, _} -> :ok
          _ -> :error
        end

      :error ->
        :error
    end
  end

  def get_media_paginated(page, rpp) do
    MediaFileDao.get_from_path_paginated(@media_path, page, rpp)
  end

  def delete_media(id) do
    MediaFileDao.delete(id)
  end

  defp get_media_name(%MediaFile{content_type: content_type}) do
    cond do
      String.starts_with?(content_type, "image") -> {:ok, "#{UUID.uuid1()}.jpg"}
      String.starts_with?(content_type, "video") -> {:ok, "#{UUID.uuid1()}.mp4"}
      true -> :error
    end
  end
end
