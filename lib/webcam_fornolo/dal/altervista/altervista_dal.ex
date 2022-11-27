defmodule WebcamFornolo.Dal.Altervista.AltervistaDal do
  require Logger

  @host 'ftp.webcamfornolo.altervista.org'
  @local_save_directory '/tmp/'
  @resurce_base_path "https://webcamfornolo.altervista.org"

  def get_image(name, remote_folder) do
    try do
      {:ok, pid} = :ftp.open(@host)
      :ok = :ftp.user(pid, user, password)
      :ok = :ftp.type(pid, :binary)

      :ok = :ftp.cd(pid, '#{remote_folder}')

      local_path = "#{@local_save_directory}#{name}"
      :ok = :ftp.recv(pid, to_charlist(name), to_charlist(local_path))
      :ftp.close(pid)

      {:ok, local_path}
    rescue
      error ->
        Logger.error(inspect(error))
        :error
    end
  end

  def get_media_path(media_details) do
    "#{@resurce_base_path}/#{media_details.path}"
  end

  def save_file(media_details, remote_folder) do
    try do
      {:ok, pid} = :ftp.open(@host)
      :ok = :ftp.user(pid, user(), password())
      :ok = :ftp.type(pid, :binary)

      :ok = :ftp.cd(pid, '#{remote_folder}')
      :ok = :ftp.send(pid, media_details.path, '#{media_details.name}')
      :ftp.close(pid)

      :ok
    rescue
      _ -> :error
    end
  end

  def delete_file(name, remote_folder) do
    try do
      {:ok, pid} = :ftp.open(@host)
      :ok = :ftp.user(pid, user(), password())
      :ok = :ftp.type(pid, :binary)

      :ok = :ftp.cd(pid, '#{remote_folder}')

      :ok = :ftp.delete(pid, '#{name}')
      :ftp.close(pid)

      :ok
    rescue
      _ -> :error
    end
  end

  defp user, do: to_charlist(Application.get_env(:webcam_fornolo, :altervista_ftp_user))

  defp password,
    do: to_charlist(Application.get_env(:webcam_fornolo, :altervista_ftp_password))
end
