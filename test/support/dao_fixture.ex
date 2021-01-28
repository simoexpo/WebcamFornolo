defmodule WebcamFornolo.DaoFixtures do
  defmodule DummyWeatherDataDao do
    defmodule SuccessImpl do
      def get_weather_data(), do: {:ok, :data}
    end

    defmodule ErrorImpl do
      def get_weather_data(), do: :error
    end
  end
end
