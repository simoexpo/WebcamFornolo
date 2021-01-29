defmodule WebcamFornolo.Dal.Netatmo.NetatmoDalTest do
  use ExUnit.Case

  alias WebcamFornolo.Dal.Netatmo.NetatmoDal
  alias WebcamFornolo.Util.DateTimeUtil

  @cache_key :netatmo_token

  test "NetatmoDal should get a valid access token and cache it" do
    {:ok, token} = NetatmoDal.get_access_token()
    assert is_binary(token) == true
    assert NetatmoDal.get_access_token() == {:ok, token}
  end

  test "NetatmoDal should refresh a valid access token if cached token is expired" do
    {:ok, original_token} = NetatmoDal.get_access_token()
    expiry_token()
    assert NetatmoDal.get_access_token() == {:ok, original_token}
  end

  test "NetatmoDal should get weather data" do
    {:ok, token} = NetatmoDal.get_access_token()
    {:ok, data} = NetatmoDal.get_weather_data(token)
    assert is_map(data)
  end

  defp expiry_token do
    cache = Application.get_env(:webcam_fornolo, :app_cache)
    {:ok, {token, _}} = Cachex.get(cache, @cache_key)
    Cachex.put(cache, @cache_key, {token, DateTimeUtil.now() |> Timex.shift(seconds: -10)})
  end
end
