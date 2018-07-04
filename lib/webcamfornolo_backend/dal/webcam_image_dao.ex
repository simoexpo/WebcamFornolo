defmodule WebcamfornoloBackend.Dal.WebcamImageDao do
  alias WebcamfornoloBackend.Model.WebcamImage
  alias WebcamfornoloBackend.Dal.Altervista.AltervistaDal

  @webcam1_file "01.jpg"
  @webcam2_file "02.jpg"

  def get_webcam(id) do
    case AltervistaDal.get_image(webcam_to_file_name(id)) do
      {:ok, file_path, created_at} ->
        WebcamImage.create(%{path: file_path, created_at: created_at})

      _ ->
        :error
    end
  end

  defp webcam_to_file_name(id) do
    case id do
      "1" -> @webcam1_file
      "2" -> @webcam2_file
      _ -> :error
    end
  end
end
