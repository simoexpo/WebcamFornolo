defmodule WebcamFornolo.Model.WeatherData do
  alias WebcamFornolo.Model.IndoorWeatherData
  alias WebcamFornolo.Model.OutdoorWeatherData

  @type t() :: %__MODULE__{}

  @fields %{
    indoor_weather_data: IndoorWeatherData,
    outdoor_weather_data: OutdoorWeatherData,
    time: DateTime
  }

  use SafeExStruct
end
