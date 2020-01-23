defmodule WebcamFornolo.Model.IndoorWeatherData do
  @fields %{
    min_temp: :number,
    max_temp: :number,
    temperature: :number,
    pressure: :number,
    noise: :number,
    humidity: :number,
    co2: :number
  }

  use SafeExStruct
end
