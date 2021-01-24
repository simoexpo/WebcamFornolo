defmodule WebcamFornolo.Routes.WeatherRouteTest do
  use ExUnit.Case
  use Plug.Test

  alias WebcamFornolo.Routes
  alias WebcamFornolo.ServiceFixtures.DummyWeatherService

  @opts Routes.init(weather_provider: DummyWeatherService)

  test "GET /api/weather should return 200 OK with weather data" do
    conn =
      :get
      |> conn("/api/weather")
      |> Routes.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert Jason.decode!(conn.resp_body) == %{"data1" => "weather data 1", "data2" => "weather data 2"}
  end
end
