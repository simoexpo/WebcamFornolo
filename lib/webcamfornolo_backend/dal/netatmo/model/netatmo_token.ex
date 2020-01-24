defmodule WebcamFornolo.Dal.Netatmo.Model.NetatmoToken do

  alias WebcamFornolo.Dal.Netatmo.Model.NetatmoToken
  alias ElixAtmo.Model.Token
  alias WebcamFornolo.Util.DateTimeUtil

  @type t() :: %__MODULE__{}

  @fields %{
    access_token: :binary,
    refresh_token: :binary,
    expires_at: DateTime
  }

  use SafeExStruct

  @spec from(%Token{}) :: {:ok, NetatmoToken.t()} | {:error, :invalid_args}
  def from(token = %Token{}) do
    expires_at = DateTimeUtil.now() |> Timex.shift(seconds: token.expires_in)

    token
    |> Map.from_struct()
    |> Map.drop([:expires_in])
    |> Map.put(:expires_at, expires_at)
    |> create(ignore_unknown_fields: true)
  end
end
