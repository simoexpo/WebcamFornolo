defmodule WebcamFornolo.Model.OutdoorWeatherData do
  @type t() :: %__MODULE__{}

  @fields %{
    min_temp: {:number, :optional, nil},
    max_temp: {:number, :optional, nil},
    temperature: {:number, :optional, nil},
    humidity: {:number, :optional, nil},
    rain: {:number, :optional, nil}
  }

  use SafeExStruct
end
