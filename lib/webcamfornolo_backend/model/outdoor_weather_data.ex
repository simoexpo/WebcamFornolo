defmodule WebcamfornoloBackend.Model.OutdoorWeatherData do
  @fields %{
    min_temp: :number,
    max_temp: :number,
    temperature: :number,
    humidity: :number,
  }

  use SafeExStruct
end
