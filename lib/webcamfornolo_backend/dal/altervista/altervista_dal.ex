defmodule WebcamfornoloBackend.Dal.Altervista.AltervistaDal do
  require Logger

  @host 'ftp.webcamfornolo.altervista.org'
  @save_directory '/tmp/'

  def get_image(name) do
    try do
      :inets.start()
      {:ok, pid} = :inets.start(:ftpc, host: @host)
      :ok = :ftp.user(pid, user(), password())
      :ok = :ftp.type(pid, :binary)

      created_at =
        :ftp.quote(pid, 'MDTM #{name}')
        |> get_last_modify_date_time()

      local_path = "#{@save_directory}#{name}"
      :ok = :ftp.recv(pid, to_charlist(name), to_charlist(local_path))
      :inets.stop(:ftpc, pid)

      {:ok, local_path, created_at}
    rescue
      _ -> :error
    end
  end

  defp get_last_modify_date_time(ftp_mdtm) do
    time_string =
      to_string(ftp_mdtm)
      |> String.split()
      |> Enum.at(1)

    Regex.run(~r/(\d\d\d\d)(\d\d)(\d\d)(\d\d)(\d\d)(\d\d)/, time_string)
    |> Enum.drop(1)
    |> Enum.join(",")
    |> Timex.parse!("{YYYY},{M},{D},{h24},{m},{s}")
    |> DateTime.from_naive!("Etc/UTC")
    |> Timex.to_datetime("Europe/Rome")
  end

  defp user, do: to_charlist(Application.get_env(:webcamfornolo_backend, :altervista_ftp_user))

  defp password,
    do: to_charlist(Application.get_env(:webcamfornolo_backend, :altervista_ftp_password))
end
