defmodule WebcamfornoloBackend.Dal.MediaFileDao do
  import Ecto.Query
  require Logger

  alias WebcamfornoloBackend.Repo
  alias WebcamfornoloBackend.Mapper.MediaDetailsMapper
  alias WebcamfornoloBackend.Dal.Db.MediaFileEntity
  alias WebcamfornoloBackend.Dal.Altervista.AltervistaDal

  def get(file_name) do
    case Repo.get_by(MediaFileEntity, name: file_name) do
      nil ->
        :error

      media_file = %MediaFileEntity{} ->
        Logger.info("found media on DB")

        case AltervistaDal.get_image(media_file.name, media_file.path) do
          {:ok, file_path} ->
            Logger.info("retrieved media on server")
            MediaDetailsMapper.from(media_file, file_path)

          _ ->
            :error
        end

      _ ->
        :error
    end
  end

  def get_from_path_paginated(path, page, rpp) do
    {entities, total_pages} =
      MediaFileEntity
      |> where([e], e.path == ^path)
      |> Repo.paginated(page, rpp)

    items =
      entities
      |> Enum.map(fn x -> elem(MediaDetailsMapper.from(x), 1) end)
      |> Enum.map(fn x ->
        media_path = AltervistaDal.get_media_path(x)
        Map.put(x, :path, media_path)
      end)

    {:ok, %{total_pages: total_pages, items: items}}
  end

  def save(media_details, remote_path) do
    Logger.info("saving media on server")

    case AltervistaDal.save_file(media_details, remote_path) do
      :ok ->
        Logger.info("saving media on DB")

        Map.replace!(media_details, :path, remote_path)
        |> MediaFileEntity.from()
        |> Repo.insert()

      :error ->
        :error
    end
  end

  def replace(media_details, remote_path) do
    Logger.info("replacing media on server")

    case AltervistaDal.save_file(media_details, remote_path) do
      :ok ->
        Logger.info("replacing media on DB")
        new_media_details = Map.replace!(media_details, :path, remote_path)

        case Repo.get_by(MediaFileEntity, name: media_details.name) do
          nil ->
            new_media_details
            |> MediaFileEntity.from()
            |> Repo.insert()

          media_file_entity ->
            media_file_entity
            |> MediaFileEntity.changeset(Map.from_struct(new_media_details))
            |> Repo.update()
        end

      :error ->
        :error
    end
  end
end
