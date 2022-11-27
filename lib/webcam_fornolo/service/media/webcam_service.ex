defmodule WebcamFornolo.Service.Media.WebcamService do
  require Logger

  alias WebcamFornolo.Application
  alias WebcamFornolo.Service.ImageEditorService
  alias WebcamFornolo.Dal.WeatherDataDao
  alias WebcamFornolo.Model.MediaFile
  alias WebcamFornolo.Dal.MediaFileDao
  alias WebcamFornolo.Util.DateTimeUtil

  @default_media_file_dao MediaFileDao
  @default_editor_service ImageEditorService

  @webcam1_file "01.jpg"
  @webcam2_file "02.jpg"
  @locale "it"
  @datetime_format "{WDshort} {0D} {Mshort} {YYYY} {h24}:{m}:{s}"
  @webcam1_left_label "Località Fornolo (PR) - Alta Val Ceno"
  @webcam2_left_label "Località Fornolo (PR) - Alta Val Ceno"
  @webcam_image_remote_path "webcam"

  defp webcam_ip, do: Application.get_env(:webcam_fornolo, :webcam_ip)
  defp webcam1_port, do: Application.get_env(:webcam_fornolo, :webcam1_port)
  defp webcam2_port, do: Application.get_env(:webcam_fornolo, :webcam2_port)
  defp webcam_user, do: Application.get_env(:webcam_fornolo, :webcam_user)
  defp ssh_key, do: Application.get_env(:webcam_fornolo, :ssh_key) |> String.split("\\n") |> Enum.join("\n")

  @spec get_media(String.t(), atom()) :: :error | {:ok, MediaFile.t()}
  def get_media(id, provider \\ @default_media_file_dao) do
    case provider.get(webcam_to_file_name(id)) do
      {:ok, %MediaFile{path: file_path}} -> {:ok, file_path}
      _ -> :error
    end
  end

  @spec save_media(String.t(), MediaFile.t(), atom()) :: :error | :ok
  def save_media(
        id,
        media_details = %MediaFile{path: path, created_at: created_at},
        media_provider \\ @default_media_file_dao,
        editor_service \\ @default_editor_service
      ) do
    edited_file_path = editor_service.create_webcam_view(path, leftLabel(id), rightLabel(created_at))

    Logger.info("edited!")

    edited_media_details =
      media_details
      |> Map.replace!(:path, edited_file_path)
      |> Map.replace!(:name, webcam_to_file_name(id))

    case media_provider.replace(edited_media_details, @webcam_image_remote_path) do
      {:ok, _} -> :ok
      _ -> :error
    end
  end

  @spec reset_webcam(String.t()) :: :error | :ok
  def reset_webcam(id) do
    tmp_dir = System.tmp_dir()
    tmp_key_file = Path.join(tmp_dir, "key.pem")
    File.write!(tmp_key_file, ssh_key)
    key = File.open!(tmp_key_file)
    tmp_known_hosts_file = Path.join(tmp_dir, "known_hosts")
    File.write!(tmp_known_hosts_file, "")
    known_hosts = File.open!(tmp_known_hosts_file)

    cb = SSHClientKeyAPI.with_options(identity: key, known_hosts: known_hosts, silently_accept_hosts: true)

    with {:ok, port} <- get_webcam_port(id),
         :ok <- :ssh.start(),
         _ <- Logger.info("Trying to reset webcam #{id} with #{webcam_user}@#{webcam_ip}:#{port}"),
         {:ok, _, 0} <-
           SSHKit.context([{webcam_ip, port: port}], user: webcam_user, key_cb: cb) |> SSHKit.run("sudo reboot") do
      :ok
    else
      error ->
        Logger.error(fn -> "#{inspect(error)}" end)
        :error
    end
  end

  @spec get_webcam_port(String.t()) :: :error | {:ok, integer()}
  defp get_webcam_port(id) do
    case id do
      "1" -> {:ok, String.to_integer(webcam1_port)}
      "2" -> {:ok, String.to_integer(webcam2_port)}
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
