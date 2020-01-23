defmodule WebcamFornolo.Service.WeatherService do

  @default_weather_dao_impl WeatherDataDaoImpl

  defprotocol WeatherDataDao do
    def get_weather_data(impl)
  end

  defmodule WeatherDataDaoImpl do

    defimpl WeatherDataDao, for: WeatherDataDaoImpl do
      def get_weather_data(impl), do: fn env -> env.dal end
    end
  end

  def get_weather_info(provider \\ @default_weather_dao_impl) do
    WeatherDataDao.get_weather_data(provider)
  end
end
