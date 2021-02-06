defmodule WebcamFornolo.Dal.WeatherDataDaoTest do
  use ExUnit.Case

  alias WebcamFornolo.Dal.WeatherDataDao
  alias WebcamFornolo.Dal.WeatherDataDaoTest.DummyWeatherDataProvider
  alias WebcamFornolo.DataFixture

  test "WeatherDataDao should get weather data" do
    reset_cache()
    {:ok, data} = WeatherDataDao.get_weather_data(DummyWeatherDataProvider.SuccessImpl)
    assert data == DataFixture.weather_data()
  end

  test "WeatherDataDao should cache weather data" do
    reset_cache()
    {:ok, data} = WeatherDataDao.get_weather_data(DummyWeatherDataProvider.SuccessImpl)
    {:ok, cached_data} = WeatherDataDao.get_weather_data(DummyWeatherDataProvider.UnavailableImpl)
    assert data == cached_data
  end

  test "WeatherDataDao should return :error if weather data is not available" do
    reset_cache()
    assert WeatherDataDao.get_weather_data(DummyWeatherDataProvider.UnavailableImpl) == :error
  end

  defp reset_cache do
    cache = Application.get_env(:webcam_fornolo, :app_cache)
    Cachex.reset(cache)
  end

  defmodule DummyWeatherDataProvider do
    defmodule SuccessImpl do
      def get_weather() do
        {:ok, DataFixture.raw_weather_data()}
      end
    end

    defmodule UnavailableImpl do
      def get_weather() do
        :error
      end
    end
  end
end
