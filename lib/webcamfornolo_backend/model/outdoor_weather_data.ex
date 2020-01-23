defmodule WebcamFornolo.Model.OutdoorWeatherData do
  @fields %{
    min_temp: :number,
    max_temp: :number,
    temperature: :number,
    humidity: :number,
    rain: :number
  }

  use SafeExStruct
end
