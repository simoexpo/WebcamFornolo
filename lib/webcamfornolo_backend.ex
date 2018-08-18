defmodule WebcamfornoloBackend do
  alias WebcamfornoloBackend.Dal.WeatherDataDao
  alias WebcamfornoloBackend.Service.WebcamImageService
  alias WebcamfornoloBackend.Service.MediaFileService
  alias WebcamfornoloBackend.Mapper.MediaDetailsMapper

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

  def save_webcam(id, webcam_image) do
    case MediaDetailsMapper.from(webcam_image) do
      {:ok, media_details} -> WebcamImageService.save_webcam(id, media_details)
      _ -> :error
    end
  end

  def save_media(media_data) do
    case MediaDetailsMapper.from(media_data) do
      {:ok, media_details} -> MediaFileService.save_media(media_details)
      :error -> :error
    end
  end
end
