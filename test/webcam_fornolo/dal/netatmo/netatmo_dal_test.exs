# TODO netatmo not working anymore with grant type password
# defmodule WebcamFornolo.Dal.Netatmo.NetatmoDalTest do
#   use ExUnit.Case

#   alias WebcamFornolo.Dal.Netatmo.NetatmoDal
#   alias WebcamFornolo.Util.DateTimeUtil

#   @cache_key :netatmo_token

#   test "NetatmoDal should get weather info" do
#     {:ok, data} = NetatmoDal.get_weather()
#     assert is_map(data)
#   end

#   test "NetatmoDal should cache the access token to retrieve weather info" do
#     {:ok, _} = NetatmoDal.get_weather()
#     {:ok, original_token} = retrieve_token()
#     {:ok, _} = NetatmoDal.get_weather()
#     assert retrieve_token() == {:ok, original_token}
#   end

#   test "NetatmoDal should refresh the access token if cached token is expired" do
#     {:ok, _} = NetatmoDal.get_weather()
#     {:ok, original_token} = retrieve_token()
#     expiry_token()
#     {:ok, _} = NetatmoDal.get_weather()
#     {:ok, new_token} = retrieve_token()
#     assert original_token == new_token
#   end

#   defp expiry_token do
#     cache = Application.get_env(:webcam_fornolo, :app_cache)
#     {:ok, {token, _}} = Cachex.get(cache, @cache_key)
#     Cachex.put(cache, @cache_key, {token, DateTimeUtil.now() |> Timex.shift(seconds: -10)})
#   end

#   defp retrieve_token do
#     cache = Application.get_env(:webcam_fornolo, :app_cache)
#     {:ok, {token, _}} = Cachex.get(cache, @cache_key)
#     {:ok, token}
#   end
# end
