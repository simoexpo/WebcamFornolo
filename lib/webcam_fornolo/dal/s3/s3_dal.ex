defmodule WebcamFornolo.Dal.S3.S3Dal do
  alias ExAws.S3
  require Logger

  @resurce_base_path "https://s3.tebi.io"
  @bucket "webcamfornolo"

  @spec get_media_path(atom | %{:path => any, optional(any) => any}) :: <<_::64, _::_*8>>
  def get_media_path(media_details) do
    "#{@resurce_base_path}/#{@bucket}/#{media_details.path}/#{media_details.name}"
  end

  @spec save_file(atom | %{:name => any, optional(any) => any}, any) :: :error | :ok
  def save_file(media_details, remote_folder) do
    Logger.debug("Try to save file on S3 to bucket #{@bucket} and path #{remote_folder}/#{media_details.name}")
    file = File.read!(media_details.path)
    md5 = :crypto.hash(:md5, file) |> Base.encode64()
    result = S3.put_object(@bucket, "#{remote_folder}/#{media_details.name}", file, content_md5: md5, acl: :public_read)
    |> ExAws.request
    case result do
      {:ok, _} -> :ok
      {:error, error} ->
        Logger.error("Failed to save file on S3, caused by: #{inspect(error)}")
        :error
    end
  end

  def delete_file(name, remote_folder) do
    result = S3.delete_object(@bucket, "#{remote_folder}/#{name}")
    |> ExAws.request
    case result do
      {:ok, _} -> :ok
      {:error, error} ->
        Logger.error("Failed to delete file from S3, caused by: #{inspect(error)}")
        :error
    end
  end
end
