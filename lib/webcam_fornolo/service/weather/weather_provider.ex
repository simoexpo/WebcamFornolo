defmodule WebcamFornolo.Service.Weather.WeatherProvider do
  @moduledoc """
  General behavior for weather provider.
  """

  alias WebcamFornolo.Model.WeatherData

  @doc """
  Check if a given token is valid
  """
  @callback get_weather_info(atom()) :: :error | {:ok, WeatherData.t()}
end
