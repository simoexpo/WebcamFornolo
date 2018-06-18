defmodule WebcamfornoloBackend do
  @moduledoc """
  WebcamfornoloBackend keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  @get_weather "https://api.netatmo.com/api/getstationsdata"
  @token "token"

  def getWeatherInfo() do
    url = getWeatherUrl(@token)

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        IO.puts(body)

      {:ok, %HTTPoison.Response{status_code: code, body: body}} ->
        IO.puts("Error while getting weather info: status code was #{code} with body #{body}")

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect(reason)
    end
  end

  defp getWeatherUrl(token, device_id \\ nil) do
    params =
      case {token, device_id} do
        {_, nil} -> "access_token=#{token}"
        {_, _} -> "#access_token=#{token}&device_id=#{device_id}"
      end

    "#{@get_weather}?#{params}"
  end
end
