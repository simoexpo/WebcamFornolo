defmodule WebcamFornolo.Model.IndoorWeatherData do
  @type t() :: %__MODULE__{}

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
