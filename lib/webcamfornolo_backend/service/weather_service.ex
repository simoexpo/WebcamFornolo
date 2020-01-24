defmodule WebcamFornolo.Service.WeatherService do

  alias WebcamFornolo.Dal.WeatherDataDao
  alias WebcamFornolo.Model.WeatherData

  @default_weather_dao_impl WeatherDataDao

  @spec get_weather_info(atom()) :: :error | {:ok, WeatherData.t()}
  def get_weather_info(provider \\ @default_weather_dao_impl) do
    provider.get_weather_data()
  end
end
