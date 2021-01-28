defmodule WebcamFornolo.Routes.WeatherRouteTest do
  use ExUnit.Case
  use Plug.Test

  alias WebcamFornolo.Routes
  alias WebcamFornolo.ServiceFixtures.DummyWeatherService

  @success_opts Routes.init(weather_provider: DummyWeatherService.SuccessImpl)
  @error_opts Routes.init(weather_provider: DummyWeatherService.ErrorImpl)

  test "GET /api/weather should return 200 OK with weather data" do
    conn =
      :get
      |> conn("/api/weather")
      |> Routes.call(@success_opts)

    assert conn.state == :sent
    assert conn.status == 200

    assert Jason.decode!(conn.resp_body) == %{
             "indoor_weather_data" => %{
               "co2" => 544,
               "humidity" => 50,
               "max_temp" => 8.8,
               "min_temp" => 7.3,
               "noise" => 35,
               "pressure" => 1032.3,
               "temperature" => 8.4
             },
             "outdoor_weather_data" => %{
               "humidity" => 76,
               "max_temp" => 9.3,
               "min_temp" => -0.2,
               "rain" => 0,
               "temperature" => 3.3
             },
             "time" => "2020-01-23T18:08:59+01:00"
           }
  end

  test "GET /api/weather should return 500 Internal Server Error in case of unexpected error" do
    conn =
      :get
      |> conn("/api/weather")
      |> Routes.call(@error_opts)

    assert conn.state == :sent
    assert conn.status == 500
  end
end
