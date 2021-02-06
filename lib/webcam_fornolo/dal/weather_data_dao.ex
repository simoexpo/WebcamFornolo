defmodule WebcamFornolo.Dal.WeatherDataDao do
  alias WebcamFornolo.Dal.Netatmo.NetatmoDal
  alias WebcamFornolo.Mapper.WeatherDataMapper
  alias WebcamFornolo.Model.WeatherData
  alias WebcamFornolo.Model.OutdoorWeatherData

  @cache_key :weather_data
  @refresh_minutes 5
  @default_weather_provider NetatmoDal

  @spec get_weather_data(atom()) :: :error | {:ok, WeatherData.t()}
  def get_weather_data(weather_provider \\ @default_weather_provider) do
    with {:ok, nil} <- Cachex.get(cache(), @cache_key),
         {:ok, weather_info} <- weather_provider.get_weather(),
         {:ok, weather_data} <- WeatherDataMapper.from(weather_info) do
      save(weather_data)
    else
      {:ok, weather_data} -> {:ok, weather_data}
      _ -> :error
    end
  end

  # MOVE from here to service
  @spec get_outdoor_temperature() :: :error | {:ok, number()}
  def get_outdoor_temperature() do
    case get_weather_data() do
      {:ok, %WeatherData{outdoor_weather_data: %OutdoorWeatherData{temperature: temperature}}} -> {:ok, temperature}
      :error -> :error
    end
  end

  @spec save(WeatherData.t()) :: {:ok, WeatherData.t()} | :error
  defp save(weather_data) do
    case Cachex.put(cache(), @cache_key, weather_data, ttl: :timer.minutes(@refresh_minutes)) do
      {:ok, _} -> {:ok, weather_data}
      _ -> :error
    end
  end

  @spec cache() :: atom
  defp cache(), do: Application.get_env(:webcam_fornolo, :app_cache)
end
