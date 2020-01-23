defmodule WebcamfornoloBackend.Mapper.MediaDetailsMapper do
  alias WebcamfornoloBackend.Model.MediaDetails
  alias WebcamfornoloBackend.Dal.Db.MediaFileEntity
  alias WebcamfornoloBackend.Service.Util.DateTimeUtil
  require Logger

  def from(media_file_entity = %MediaFileEntity{}) do
    IO.inspect(media_file_entity)

    MediaDetails.create(%{
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

    MediaDetails.create(%{
      name: media_data.filename,
      description: Map.get(media_data, :description, nil),
      content_type: media_data.content_type,
      path: media_data.path,
      created_at: DateTimeUtil.now()
    })
  end

  def from(media_file_entity = %MediaFileEntity{}, path) do
    IO.inspect(media_file_entity)

    MediaDetails.create(%{
      id: media_file_entity.id,
      name: media_file_entity.name,
      description: media_file_entity.description,
      content_type: media_file_entity.content_type,
      path: path,
      created_at: media_file_entity.created_at
    })
  end
end
