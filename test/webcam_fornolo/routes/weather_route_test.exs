defmodule WebcamFornolo.Routes.WeatherRouteTest do
  use ExUnit.Case
  use Plug.Test

  alias WebcamFornolo.Routes
  alias WebcamFornolo.ServiceFixtures.DummyWeatherService
  alias WebcamFornolo.DataFixture

  @success_opts Routes.init(weather_provider: DummyWeatherService.SuccessImpl)
  @error_opts Routes.init(weather_provider: DummyWeatherService.ErrorImpl)

  test "GET /api/weather should return 200 OK with weather data" do
    conn =
      :get
      |> conn("/api/weather")
      |> Routes.call(@success_opts)

    assert conn.state == :sent
    assert conn.status == 200

    assert Jason.decode!(conn.resp_body) == DataFixture.weather_data_json()
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
