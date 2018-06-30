defmodule WebcamfornoloBackend.Model.WeatherData do
  alias WebcamfornoloBackend.Model.IndoorWeatherData
  alias WebcamfornoloBackend.Model.OutdoorWeatherData

  @fields %{
    indoor_weather_data: IndoorWeatherData,
    outdoor_weather_data: OutdoorWeatherData,
    time: DateTime
  }

  use SafeExStruct
end
