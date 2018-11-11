defmodule WebcamfornoloBackendWeb.JsonProtocol do
  require Protocol

  alias WebcamfornoloBackend.Model.IndoorWeatherData
  alias WebcamfornoloBackend.Model.OutdoorWeatherData
  alias WebcamfornoloBackend.Model.WeatherData

  Protocol.derive(Jason.Encoder, IndoorWeatherData)
  Protocol.derive(Jason.Encoder, OutdoorWeatherData)
  Protocol.derive(Jason.Encoder, WeatherData)
end
