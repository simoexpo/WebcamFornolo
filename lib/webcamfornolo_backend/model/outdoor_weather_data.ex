defmodule WebcamFornolo.Model.OutdoorWeatherData do

  @type t() :: %__MODULE__{}

  @fields %{
    min_temp: :number,
    max_temp: :number,
    temperature: :number,
    humidity: :number,
    rain: :number
  }

  use SafeExStruct
end
