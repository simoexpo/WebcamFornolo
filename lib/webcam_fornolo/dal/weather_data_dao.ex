defmodule WebcamFornolo.Dal.WeatherDataDao do
  alias WebcamFornolo.Dal.Netatmo.NetatmoDal
  alias WebcamFornolo.Mapper.WeatherDataMapper
  alias WebcamFornolo.Dal.NetatmoTokenDao
  alias WebcamFornolo.Model.WeatherData
  alias WebcamFornolo.Model.OutdoorWeatherData

  @key :weather_data
  @refresh_minutes 5

  @spec get_weather_data() :: :error | {:ok, WeatherData.t()}
  def get_weather_data() do
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

      _ ->
        :error
    end
  end

  @spec save(map()) :: {:ok, map()} | :error
  defp save(weather_data) do
    case Cachex.put(cache(), @key, weather_data, ttl: :timer.minutes(@refresh_minutes)) do
      {:ok, _} -> {:ok, weather_data}
      _ -> :error
    end
  end

  @spec cache() :: atom
  defp cache(), do: Application.get_env(:webcam_fornolo, :app_cache)

  @spec get_outdoor_temperature() :: :error | {:ok, number()}
  def get_outdoor_temperature() do
    case get_weather_data() do
      {:ok, %WeatherData{outdoor_weather_data: %OutdoorWeatherData{temperature: temperature}}} -> {:ok, temperature}
      :error -> :error
    end
  end
end
