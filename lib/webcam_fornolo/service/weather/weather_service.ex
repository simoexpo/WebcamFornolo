defmodule WebcamFornolo.Service.Weather.WeatherService do
  @behaviour WebcamFornolo.Service.Weather.WeatherProvider

  alias WebcamFornolo.Dal.WeatherDataDao
  alias WebcamFornolo.Model.WeatherData

  @default_weather_dao WeatherDataDao

  @spec get_weather_info(atom()) :: :error | {:ok, WeatherData.t()}
  def get_weather_info(provider \\ @default_weather_dao) do
    provider.get_weather_data()
  end
end
