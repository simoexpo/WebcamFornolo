defmodule WebcamFornolo.Dal.Db.Repo.Migrations.CreateNetatmoToken do
  use Ecto.Migration

  def change do
    create table(:netatmo_token) do
      add(:access_token, :string)
      add(:refresh_token, :string)
      add(:expires_at, :utc_datetime)
    end
  end
end
