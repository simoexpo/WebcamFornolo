defmodule WebcamfornoloBackend.Dal.WeatherDataDao do
  alias WebcamfornoloBackend.Dal.Netatmo.NetatmoDal
  alias WebcamfornoloBackend.Mapper.WeatherDataMapper
  alias WebcamfornoloBackend.Dal.NetatmoTokenDao
  alias WebcamfornoloBackend.Model.WeatherData
  alias WebcamfornoloBackend.Model.OutdoorWeatherData

  def get_weather_data do
    case NetatmoTokenDao.get_token() do
      {:ok, token} ->
        case NetatmoDal.get_weather_data(token.access_token) do
          {:ok, weather_data} -> WeatherDataMapper.from(weather_data)
          :error -> :error
        end

      :error ->
        :error
    end
  end

  def get_outdoor_temperature do
    case get_weather_data() do
      {:ok, %WeatherData{outdoor_weather_data: %OutdoorWeatherData{temperature: temperature}}} ->
        {:ok, temperature}

      _ ->
        :error
    end
  end
end
