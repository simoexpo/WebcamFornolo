defmodule WebcamFornolo.Mapper.MediaFileMapper do
  require Logger

  alias WebcamFornolo.Model.MediaFile
  alias WebcamFornolo.Dal.Db.MediaFileEntity
  alias WebcamFornolo.Util.DateTimeUtil

  @spec from(map) :: :error | {:ok, MediaFile.t()}
  def from(map)

  def from(media_file_entity = %MediaFileEntity{}) do
    from(media_file_entity, media_file_entity.path)
  end

  def from(media_data = %{}) do
    Logger.info(fn -> "#{inspect(media_data)}" end)

    case MediaFile.create(%{
           name: Map.get(media_data, :filename),
           description: Map.get(media_data, :description),
           content_type: Map.get(media_data, :content_type),
           path: Map.get(media_data, :path),
           created_at: DateTimeUtil.now()
         }) do
      {:ok, value} -> {:ok, value}
      {:error, _} -> :error
    end
  end

  @spec from(MediaFileEntity.t(), String.t()) :: :error | {:ok, MediaFile.t()}
  def from(media_file_entity = %MediaFileEntity{}, path) do
    Logger.info(fn -> "#{inspect(media_file_entity)}" end)

    case MediaFile.create(%{
           id: media_file_entity.id,
           name: media_file_entity.name,
           description: media_file_entity.description,
           content_type: media_file_entity.content_type,
           path: path,
           created_at: media_file_entity.created_at
         }) do
      {:ok, value} -> {:ok, value}
      {:error, _} -> :error
    end
  end
end
