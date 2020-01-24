defmodule WebcamFornolo.Mapper.WeatherDataMapperTest do
  use ExUnit.Case

  alias WebcamFornolo.Mapper.WeatherDataMapper
  alias WebcamFornolo.Model.IndoorWeatherData
  alias WebcamFornolo.Model.OutdoorWeatherData
  alias WebcamFornolo.Model.WeatherData

  @timezone "Europe/Rome"

  test "WeatherDataMapper should crete a WeatherData from a map" do
    expected = %WeatherData{
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
      time: Timex.from_unix(1579799339, :second) |> Timex.to_datetime(@timezone)
    }
    assert WeatherDataMapper.from(weather_data_sample()) == {:ok, expected}
  end

  test "WeatherDataMapper should fail to crete a WeatherData from an invalid map" do
    invalid_map = %{
      "key1" => "value1",
      "key2" => %{
        "key21" => "value21"
      }
    }
    assert WeatherDataMapper.from(invalid_map) == :error
  end

  defp weather_data_sample, do: %{
    "body" => %{
      "devices" => [
        %{
          "dashboard_data" => %{
            "time_utc" => 1579799047,
            "Temperature" => 8.4,
            "CO2" => 544,
            "Humidity" => 50,
            "Noise" => 35,
            "Pressure" => 1032.3,
            "AbsolutePressure" => 934.6,
            "min_temp" => 7.3,
            "max_temp" => 8.8,
            "date_max_temp" => 1579790596,
            "date_min_temp" => 1579765552,
            "temp_trend" => "stable",
            "pressure_trend" => "down"
          },
          "modules" => [
            %{
              "dashboard_data" => %{
                "time_utc" => 1579799028,
                "Temperature" => 3.3,
                "Humidity" => 76,
                "min_temp" => -0.2,
                "max_temp" => 9.3,
                "date_max_temp" => 1579783647,
                "date_min_temp" => 1579754489,
                "temp_trend" => "down"
              }
            },
            %{
              "dashboard_data" => %{
                "time_utc" => 1579799041,
                "Rain" => 0,
                "sum_rain_1" => 0,
                "sum_rain_24" => 0
              }
            }
          ]
        }
      ]
    },
    "time_server" => 1579799339
  }
end
