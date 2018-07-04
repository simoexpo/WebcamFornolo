defmodule WebcamfornoloBackend do
  alias WebcamfornoloBackend.Dal.WeatherDataDao
  alias WebcamfornoloBackend.Service.WebcamImageService

  @moduledoc """
  WebcamfornoloBackend keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def get_weather_info() do
    WeatherDataDao.get_weather_data()
  end

  def get_webcam(id) do
    WebcamImageService.get_webcam(id)
  end
end
