defmodule WebcamfornoloBackend.Service.WebcamImageService do
  alias WebcamfornoloBackend.Dal.WebcamImageDao
  alias WebcamfornoloBackend.Service.ImageEditorService
  alias WebcamfornoloBackend.Dal.WeatherDataDao
  alias WebcamfornoloBackend.Model.WebcamImage

  @locale "it"
  @datetime_format "{WDshort} {0D} {Mshort} {YYYY} {h24}:{m}:{s}"
  @webcam1_left_label "Località Fornolo (PR) - Alta Val Ceno"
  @webcam2_left_label "Località Fornolo (PR) - Alta Val Ceno"

  def get_webcam(id) do
    case WebcamImageDao.get_webcam(id) do
      {:ok, %WebcamImage{path: path, created_at: created_at}} ->
        ImageEditorService.create_webcam_view(path, leftLabel(id), rightLabel(created_at))

      _ ->
        :error
    end
  end

  defp leftLabel(id) do
    case id do
      "1" -> @webcam1_left_label
      "2" -> @webcam2_left_label
      _ -> :error
    end
  end

  defp rightLabel(created_at) do
    temp =
      case WeatherDataDao.get_outdoor_temperature() do
        {:ok, temperature} -> temperature
        :error -> "N.D"
      end

    now = created_at |> Timex.lformat!(@datetime_format, @locale)
    "Temperatura: #{temp}°C - #{now}"
  end
end
