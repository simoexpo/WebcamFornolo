defmodule WebcamfornoloBackend.Service.WebcamImageService do
  alias WebcamfornoloBackend.Dal.WebcamImageDao
  alias WebcamfornoloBackend.Service.ImageEditorService
  alias WebcamfornoloBackend.Dal.WeatherDataDao

  @webcam1 "1"
  @webcam2 "2"
  @timezone "Europe/Rome"
  @locale "it"
  @datetime_format "{WDshort} {0D} {Mshort} {YYYY} {h24}:{m}:{s}"
  @webcam1_left_label "Località Fornolo (PR) - Alta Val Ceno"
  @webcam2_left_label "Località Fornolo (PR) - Alta Val Ceno"

  def get_webcam(id) do
    case id do
      @webcam1 -> get_webcam_1()
      @webcam2 -> get_webcam_2()
      _ -> :error
    end
  end

  defp get_webcam_1 do
    case WebcamImageDao.get_webcam_1() do
      {:ok, image} ->
        ImageEditorService.create_webcam_view(image, @webcam1_left_label, rightLabel())

      :error ->
        :error
    end
  end

  defp get_webcam_2 do
    case WebcamImageDao.get_webcam_2() do
      {:ok, image} ->
        ImageEditorService.create_webcam_view(image, @webcam2_left_label, rightLabel())

      :error ->
        :error
    end
  end

  defp rightLabel() do
    temp =
      case WeatherDataDao.get_outdoor_temperature() do
        {:ok, temperature} -> temperature
        :error -> "N.D"
      end

    now = Timex.now(@timezone) |> Timex.lformat!(@datetime_format, @locale)
    "Temperatura: #{temp}°C - #{now}"
  end
end
