defmodule WebcamFornolo.Mapper.MediaFileMapper do
  alias WebcamFornolo.Model.MediaFile
  alias WebcamFornolo.Dal.Db.MediaFileEntity
  alias WebcamFornolo.Util.DateTimeUtil
  require Logger

  def from(media_file_entity = %MediaFileEntity{}) do
    Logger.info(fn -> "#{inspect(media_file_entity)}" end)

    MediaFile.create(%{
      id: media_file_entity.id,
      name: media_file_entity.name,
      description: media_file_entity.description,
      content_type: media_file_entity.content_type,
      path: media_file_entity.path,
      created_at: media_file_entity.created_at
    })
  end

  def from(media_data) do
    Logger.info(fn -> "#{inspect(media_data)}" end)

    MediaFile.create(%{
      name: Map.get(media_data, :filename),
      description: Map.get(media_data, :description),
      content_type: Map.get(media_data, :content_type),
      path: Map.get(media_data, :path),
      created_at: DateTimeUtil.now()
    })
  end

  def from(media_file_entity = %MediaFileEntity{}, path) do
    Logger.info(fn -> "#{inspect(media_file_entity)}" end)

    MediaFile.create(%{
      id: media_file_entity.id,
      name: media_file_entity.name,
      description: media_file_entity.description,
      content_type: media_file_entity.content_type,
      path: path,
      created_at: media_file_entity.created_at
    })
  end
end
