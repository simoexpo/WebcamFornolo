defmodule WebcamFornolo.JsonProtocol do
  require Protocol

  alias WebcamFornolo.Model.IndoorWeatherData
  alias WebcamFornolo.Model.OutdoorWeatherData
  alias WebcamFornolo.Model.WeatherData

  Protocol.derive(Jason.Encoder, IndoorWeatherData)
  Protocol.derive(Jason.Encoder, OutdoorWeatherData)
  Protocol.derive(Jason.Encoder, WeatherData)
end
