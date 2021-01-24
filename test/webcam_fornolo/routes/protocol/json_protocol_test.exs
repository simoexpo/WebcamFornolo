defmodule WebcamFornolo.Routes.Protocol.JsonProtocolTest do
  use ExUnit.Case

  alias WebcamFornolo.Model.IndoorWeatherData
  alias WebcamFornolo.Model.OutdoorWeatherData
  alias WebcamFornolo.Model.WeatherData

  @timezone "Europe/Rome"

  test "JsonProtocol should provide encoder for WeatherData" do
    weather_data = %WeatherData{
      indoor_weather_data: %IndoorWeatherData{
        min_temp: 7.3,
        max_temp: 8.8,
        temperature: 8.4,
        pressure: 1032.3,
        noise: 35,
        humidity: 50,
        co2: 544
      },
      outdoor_weather_data: %OutdoorWeatherData{
        min_temp: -0.2,
        max_temp: 9.3,
        temperature: 3.3,
        humidity: 76,
        rain: 0
      },
      time: Timex.from_unix(1_579_799_339, :second) |> Timex.to_datetime(@timezone)
    }

    expected_json =
      "{\"indoor_weather_data\":{\"co2\":544,\"humidity\":50,\"max_temp\":8.8,\"min_temp\":7.3,\"noise\":35,\"pressure\":1032.3,\"temperature\":8.4},\"outdoor_weather_data\":{\"humidity\":76,\"max_temp\":9.3,\"min_temp\":-0.2,\"rain\":0,\"temperature\":3.3},\"time\":\"2020-01-23T18:08:59+01:00\"}"

    assert Jason.encode(weather_data) == {:ok, expected_json}
  end
end
