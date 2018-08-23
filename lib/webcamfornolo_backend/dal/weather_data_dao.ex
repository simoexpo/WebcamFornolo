defmodule WebcamfornoloBackend.Dal.WeatherDataDao do
  alias WebcamfornoloBackend.Dal.Netatmo.NetatmoDal
  alias WebcamfornoloBackend.Mapper.WeatherDataMapper
  alias WebcamfornoloBackend.Dal.NetatmoTokenDao
  alias WebcamfornoloBackend.Model.WeatherData
  alias WebcamfornoloBackend.Model.OutdoorWeatherData

  @key :weather_data
  @refresh_minutes 5

  def get_weather_data do
    case Cachex.get(cache(), @key) do
      {:ok, nil} ->
        case NetatmoTokenDao.get_token() do
          {:ok, token} ->
            case NetatmoDal.get_weather_data(token.access_token) do
              {:ok, weather_data} ->
                save(weather_data)
                WeatherDataMapper.from(weather_data)

              :error ->
                :error
            end

          :error ->
            :error
        end

      {:ok, weather_data} ->
        WeatherDataMapper.from(weather_data)
    end
  end

  defp save(weather_data) do
    case Cachex.put(cache(), @key, weather_data, ttl: :timer.minutes(@refresh_minutes)) do
      {:ok, _} -> {:ok, weather_data}
      _ -> :error
    end
  end

  defp cache(), do: Application.get_env(:webcamfornolo_backend, :app_cache)

  def get_outdoor_temperature do
    case get_weather_data() do
      {:ok, %WeatherData{outdoor_weather_data: %OutdoorWeatherData{temperature: temperature}}} ->
        {:ok, temperature}

      _ ->
        :error
    end
  end
end
