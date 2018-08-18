defmodule WebcamfornoloBackend.Service.WebcamImageService do
  alias WebcamfornoloBackend.Dal.WebcamImageDao
  alias WebcamfornoloBackend.Service.ImageEditorService
  alias WebcamfornoloBackend.Dal.WeatherDataDao
  alias WebcamfornoloBackend.Model.WebcamImage
  alias WebcamfornoloBackend.Model.MediaDetails
  alias WebcamfornoloBackend.Dal.MediaFileDao
  alias WebcamfornoloBackend.Service.Util.DateTimeUtil

  @locale "it"
  @datetime_format "{WDshort} {0D} {Mshort} {YYYY} {h24}:{m}:{s}"
  @webcam1_left_label "Località Fornolo (PR) - Alta Val Ceno"
  @webcam2_left_label "Località Fornolo (PR) - Alta Val Ceno"
  @webcam1_file "01.jpg"
  @webcam2_file "02.jpg"
  @webcam_image_remote_path "webcam"

  def get_webcam(id) do
    case MediaFileDao.get(webcam_to_file_name(id)) do
      {:ok, %MediaDetails{path: file_path}} -> file_path
      _ -> :error
    end
  end

  def save_webcam(id, media_details = %MediaDetails{path: path, created_at: created_at}) do
    edited_file_path =
      ImageEditorService.create_webcam_view(path, leftLabel(id), rightLabel(created_at))

    IO.inspect("edited!")

    edited_media_details =
      media_details
      |> Map.replace!(:path, edited_file_path)
      |> Map.replace!(:name, webcam_to_file_name(id))

    case MediaFileDao.replace(edited_media_details, @webcam_image_remote_path) do
      {:ok, _} -> :ok
      _ -> :error
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

    now = created_at |> DateTimeUtil.to_local() |> Timex.lformat!(@datetime_format, @locale)
    "Temperatura: #{temp}°C - #{now}"
  end

  defp webcam_to_file_name(id) do
    case id do
      "1" -> @webcam1_file
      "2" -> @webcam2_file
      _ -> :error
    end
  end
end
