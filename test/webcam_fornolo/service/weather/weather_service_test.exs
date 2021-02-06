defmodule WebcamFornolo.Service.Weather.WeatherServiceTest do
  use ExUnit.Case

  alias WebcamFornolo.Service.Weather.WeatherService
  alias WebcamFornolo.DaoFixtures.DummyWeatherDataDao

  test "WeatherService should return weather data" do
    result = WeatherService.get_weather_info(DummyWeatherDataDao.SuccessImpl)
    assert result == {:ok, :data}
  end

  test "WeatherService should return :error in case of failure" do
    result = WeatherService.get_weather_info(DummyWeatherDataDao.ErrorImpl)
    assert result == :error
  end
end
