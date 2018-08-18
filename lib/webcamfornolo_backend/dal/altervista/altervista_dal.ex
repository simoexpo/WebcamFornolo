defmodule WebcamfornoloBackend.Dal.Altervista.AltervistaDal do
  require Logger

  @host 'ftp.webcamfornolo.altervista.org'
  @save_directory '/tmp/'

  def get_image(name, remote_folder) do
    try do
      :inets.start()
      {:ok, pid} = :inets.start(:ftpc, host: @host)
      :ok = :ftp.user(pid, user(), password())
      :ok = :ftp.type(pid, :binary)

      :ok = :ftp.cd(pid, '#{remote_folder}')

      local_path = "#{@save_directory}#{name}"
      :ok = :ftp.recv(pid, to_charlist(name), to_charlist(local_path))
      :inets.stop(:ftpc, pid)

      {:ok, local_path}
    rescue
      _ -> :error
    end
  end

  def save_file(media_details, remote_folder) do
    try do
      :inets.start()
      {:ok, pid} = :inets.start(:ftpc, host: @host)
      :ok = :ftp.user(pid, user(), password())
      :ok = :ftp.type(pid, :binary)

      :ok = :ftp.cd(pid, '#{remote_folder}')
      :ok = :ftp.send(pid, media_details.path, '#{media_details.name}')

      :inets.stop(:ftpc, pid)

      :ok
    rescue
      _ -> :error
    end
  end

  defp user, do: to_charlist(Application.get_env(:webcamfornolo_backend, :altervista_ftp_user))

  defp password,
    do: to_charlist(Application.get_env(:webcamfornolo_backend, :altervista_ftp_password))
end
