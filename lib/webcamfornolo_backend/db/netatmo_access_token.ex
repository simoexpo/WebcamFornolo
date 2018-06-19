defmodule WebcamfornoloBackend.Db.NetatmoAccessToken do
  use Ecto.Schema

  schema "netmo_access_token" do
    field(:access_token, :string)
    field(:expires_in, :integer)
    field(:refresh_token, :string)
  end

  def changeset(access_token, params \\ %{}) do
    access_token
    |> Ecto.Changeset.cast(params, [:access_token, :expires_in, :refresh_token])
    |> Ecto.Changeset.validate_required([:access_token, :expires_in, :refresh_token])
  end
end
