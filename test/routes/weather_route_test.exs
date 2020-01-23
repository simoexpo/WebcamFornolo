defmodule WebcamFornolo.WeatherRouteTest do
  use ExUnit.Case
  use Plug.Test

  alias WebcamFornolo.Routes
  alias WebcamFornolo.WeatherRouteTest.FakeWeatherService

  @opts Routes.init([])

  test "GET /weather should return 200 OK with weather data" do
    conn = :get
    |> conn("/weather")
    |> assign(:provider, FakeWeatherService)
    |> Routes.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert Jason.decode!(conn.resp_body) == %{"data1" => "weather data 1", "data2" => "weather data 2"}
  end

  defmodule FakeWeatherService do
    def get_weather_info do
      {:ok, %{data1: "weather data 1", data2: "weather data 2"}}
    end
  end
end
