defmodule WebcamFornolo.Service.WeatherServiceTest do
  use ExUnit.Case

  alias WebcamFornolo.Service.WeatherService
  alias WebcamFornolo.Service.WeatherServiceTest.FakeWeatherDataDao

  test "WeatherService should return weather data" do
    result = WeatherService.get_weather_info(FakeWeatherDataDao.SuccessImpl)
    assert result == {:ok, :data}
  end

  test "WeatherService should return :error in case of failure" do
    result = WeatherService.get_weather_info(FakeWeatherDataDao.ErrorImpl)
    assert result == :error
  end

  defmodule FakeWeatherDataDao do
    defmodule SuccessImpl do
      def get_weather_data(), do: {:ok, :data}
    end
    defmodule ErrorImpl do
      def get_weather_data(), do: :error
    end
  end
end
