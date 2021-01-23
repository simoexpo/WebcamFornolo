defmodule WebcamFornolo.Dal.Db.Repo.Migrations.CreateMediaFileTable do
  use Ecto.Migration

  def change do
    create table(:media_file) do
      add(:name, :string)
      add(:path, :string)
      add(:description, :string)
      add(:content_type, :string)
      add(:created_at, :utc_datetime)
    end

    create(index(:media_file, [:name, :path], unique: true))
  end
end
