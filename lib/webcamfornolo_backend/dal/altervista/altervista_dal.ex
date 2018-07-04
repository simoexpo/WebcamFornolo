defmodule WebcamfornoloBackend.Dal.Altervista.AltervistaDal do
  alias WebcamfornoloBackend.Dal.Altervista.Model.FileInfo
  require Logger

  @host 'ftp.webcamfornolo.altervista.org'
  @save_directory '/tmp/'

  def get_image(name) do
    try do
      :inets.start()
      {:ok, pid} = :inets.start(:ftpc, host: @host)
      :ok = :ftp.user(pid, user(), password())
      :ok = :ftp.type(pid, :binary)
      {:ok, output} = :ftp.ls(pid)

      created_at =
        ls_to_file_list(to_string(output))
        |> Enum.find(fn %FileInfo{file_name: file_name} -> file_name == name end)
        |> Map.get(:created_at)

      local_path = "#{@save_directory}#{name}"
      :ok = :ftp.recv(pid, to_charlist(name), to_charlist(local_path))
      :inets.stop(:ftpc, pid)

      {:ok, local_path, created_at}
    rescue
      _ -> :error
    end
  end

  defp ls_to_file_list(ls_output) do
    String.split(ls_output, "\r\n")
    |> Enum.map(fn x -> String.split(x) |> Enum.drop(5) end)
    |> Enum.filter(fn x -> Enum.count(x) == 4 end)
    |> Enum.map(fn [month, day, year_or_time, file_name] ->
      FileInfo.from(day, month, year_or_time, file_name)
    end)
    |> Enum.filter(fn x -> x != :error end)
  end

  defp user, do: to_charlist(Application.get_env(:webcamfornolo_backend, :altervista_ftp_user))

  defp password,
    do: to_charlist(Application.get_env(:webcamfornolo_backend, :altervista_ftp_password))
end
