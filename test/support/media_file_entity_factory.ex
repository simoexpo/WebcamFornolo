defmodule WebcamFornolo.MediaFileEntityFactory do
  alias WebcamFornolo.Dal.Db.Repo
  alias WebcamFornolo.Dal.Db.MediaFileEntity
  alias WebcamFornolo.Util.DateTimeUtil

  @one_year_in_seconds 60 * 60 * 24 * 365

  @spec a_media_file :: MediaFileEntity.t()
  def a_media_file() do
    %MediaFileEntity{
      name: UUID.uuid1(),
      path: "#{UUID.uuid1()}/#{UUID.uuid1()}",
      description: UUID.uuid1(),
      content_type: "jpg",
      created_at:
        DateTimeUtil.now() |> DateTime.add(:rand.uniform(@one_year_in_seconds), :second) |> DateTime.truncate(:second)
    }
  end

  @spec insert!(MediaFileEntity.t()) :: MediaFileEntity.t()
  def insert!(media_file_entity) do
    media_file_entity |> Repo.insert!()
  end
end
