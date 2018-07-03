defmodule WebcamfornoloBackend.Dal.WebcamImageDao do
  @webcam1_url "http://webcamfornolo.altervista.org/01.jpg"
  @webcam2_url "http://webcamfornolo.altervista.org/02.jpg"
  @webcam1_path "/tmp/webcam1.jpg"
  @webcam2_path "/tmp/webcam2.jpg"

  def get_webcam_1() do
    case HTTPoison.get(@webcam1_url) do
      {:ok, %HTTPoison.Response{body: body}} -> save_file(@webcam1_path, body)
      _ -> :error
    end
  end

  def get_webcam_2() do
    case HTTPoison.get(@webcam2_url) do
      {:ok, %HTTPoison.Response{body: body}} -> save_file(@webcam2_path, body)
      _ -> :error
    end
  end

  defp save_file(path, file) do
    case File.write(path, file) do
      :ok -> {:ok, path}
      {:error, _} -> :error
    end
  end
end
