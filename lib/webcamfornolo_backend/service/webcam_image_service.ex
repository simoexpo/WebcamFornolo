defmodule WebcamFornolo.Service.WebcamImageService do
  require Logger

  alias WebcamFornolo.Service.ImageEditorService
  alias WebcamFornolo.Dal.WeatherDataDao
  alias WebcamFornolo.Model.MediaFile
  alias WebcamFornolo.Dal.MediaFileDao
  alias WebcamFornolo.Util.DateTimeUtil

  @webcam1_file "01.jpg"
  @webcam2_file "02.jpg"
  @locale "it"
  @datetime_format "{WDshort} {0D} {Mshort} {YYYY} {h24}:{m}:{s}"
  @webcam1_left_label "Località Fornolo (PR) - Alta Val Ceno"
  @webcam2_left_label "Località Fornolo (PR) - Alta Val Ceno"
  @webcam_image_remote_path "webcam"

  @spec get_webcam(String.t) :: :error | {:ok, MediaFile.t()}
  def get_webcam(id) do
    case MediaFileDao.get(webcam_to_file_name(id)) do
      {:ok, %MediaFile{path: file_path}} -> file_path
      _ -> :error
    end
  end

  @spec save_webcam(String.t, MediaFile.t()) :: :error | :ok
  def save_webcam(id, media_details = %MediaFile{path: path, created_at: created_at}) do
    edited_file_path =
      ImageEditorService.create_webcam_view(path, leftLabel(id), rightLabel(created_at))

    Logger.info("edited!")

    edited_media_details =
      media_details
      |> Map.replace!(:path, edited_file_path)
      |> Map.replace!(:name, webcam_to_file_name(id))

    case MediaFileDao.replace(edited_media_details, @webcam_image_remote_path) do
      {:ok, _} -> :ok
      _ -> :error
    end
  end

  @spec leftLabel(String.t()) :: String.t()
  defp leftLabel(id) do
    case id do
      "1" -> @webcam1_left_label
      "2" -> @webcam2_left_label
      _ -> :error
    end
  end

  @spec rightLabel(DateTime.t()) :: String.t()
  defp rightLabel(created_at) do
    temp =
      case WeatherDataDao.get_outdoor_temperature() do
        {:ok, temperature} -> "#{temperature}°C"
        :error -> "N.D"
      end

    now = created_at |> DateTimeUtil.to_local() |> Timex.lformat!(@datetime_format, @locale)
    "Temperatura: #{temp} - #{now}"
  end

  @spec webcam_to_file_name(String.t()) :: :error | String.t()
  defp webcam_to_file_name(id) do
    case id do
      "1" -> @webcam1_file
      "2" -> @webcam2_file
      _ -> :error
    end
  end
end
