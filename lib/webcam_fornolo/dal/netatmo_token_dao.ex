defmodule WebcamFornolo.Dal.NetatmoTokenDao do
  alias WebcamFornolo.Dal.Netatmo.NetatmoDal
  alias WebcamFornolo.Dal.Netatmo.Model.NetatmoToken

  @key :netatmo_token

  @spec get_token() :: :error | {:ok, NetatmoToken.t()}
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

  @spec save(NetatmoToken.t()) :: :error | {:ok, NetatmoToken.t()}
  defp save(token) do
    case Cachex.put(cache(), @key, token) do
      {:ok, _} -> {:ok, token}
      _ -> :error
    end
  end

  @spec cache() :: atom()
  defp cache(), do: Application.get_env(:webcam_fornolo, :app_cache)
end
