defmodule WebcamfornoloBackend.Dal.NetatmoTokenDao do
  alias WebcamfornoloBackend.Dal.Netatmo.NetatmoDal

  @key :netatmo_token

  def get_token() do
    case Cachex.get(cache(), @key) do
      {:ok, nil} ->
        case NetatmoDal.get_access_token() do
          {:ok, token} -> save(token)
          :error -> :error
        end

      {:ok, token} ->
        case Timex.compare(token.expires_at, Timex.now()) do
          1 ->
            {:ok, token}

          _ ->
            case NetatmoDal.refresh_access_token(token.refresh_token) do
              {:ok, token} -> save(token)
              :error -> :error
            end
        end
    end
  end

  defp save(token) do
    case Cachex.put(cache(), @key, token) do
      {:ok, _} -> {:ok, token}
      _ -> :error
    end
  end

  defp cache(), do: Application.get_env(:webcamfornolo_backend, :app_cache)
end
