defmodule WebcamfornoloBackend.Dal.Db.MediaFileEntity do
  use Ecto.Schema
  import Ecto.Changeset
  alias WebcamfornoloBackend.Dal.Db.MediaFileEntity
  alias WebcamfornoloBackend.Model.MediaDetails

  schema "media_file" do
    field(:name, :string)
    field(:path, :string)
    field(:content_type, :string)
    field(:created_at, :utc_datetime)
  end

  def from(%MediaDetails{} = media_details) do
    changeset(%MediaFileEntity{}, media_details)
  end

  @doc false
  def changeset(%MediaFileEntity{} = media_file, attrs) do
    media_file
    |> cast(attrs, [:name, :content_type, :path, :created_at])
    |> validate_required([:name, :content_type, :path, :created_at])
  end
end
