defmodule WebcamfornoloBackend.Dal.Netatmo.Model.NetatmoToken do
  alias ElixAtmo.Model.Token
  alias WebcamfornoloBackend.Service.Util.DateTimeUtil

  @fields %{
    access_token: :binary,
    refresh_token: :binary,
    expires_at: DateTime
  }

  use SafeExStruct

  def from(token = %Token{}) do
    expires_at = DateTimeUtil.now() |> Timex.shift(seconds: token.expires_in)

    token
    |> Map.from_struct()
    |> Map.drop([:expires_in])
    |> Map.put(:expires_at, expires_at)
    |> create(ignore_unknown_fields: true)
  end
end
