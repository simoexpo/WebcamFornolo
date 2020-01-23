defmodule WebcamFornolo.Dal.Db.MediaFileEntity do
  use Ecto.Schema
  import Ecto.Changeset
  alias WebcamFornolo.Dal.Db.MediaFileEntity
  alias WebcamFornolo.Model.MediaFile

  schema "media_file" do
    field(:name, :string)
    field(:path, :string)
    field(:description, :string)
    field(:content_type, :string)
    field(:created_at, :utc_datetime)
  end

  def from(%MediaFile{} = media_details) do
    changeset(%MediaFileEntity{}, Map.from_struct(media_details))
  end

  @doc false
  def changeset(%MediaFileEntity{} = media_file, attrs) do
    media_file
    |> cast(attrs, [:name, :content_type, :path, :created_at, :description])
    |> validate_required([:name, :content_type, :path, :created_at])
  end
end
