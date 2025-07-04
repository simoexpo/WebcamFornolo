defmodule WebcamFornolo.Dal.Netatmo.NetatmoDal do
  # alias ElixAtmo.Model.UserData
  alias ElixAtmo.Model.AppData
  alias ElixAtmo.Model.TokenScope
  alias ElixAtmo.Model.Token
  alias WebcamFornolo.Util.DateTimeUtil

  @cache_key :netatmo_token
  @cache Application.compile_env!(:webcam_fornolo, :app_cache)

  @token_scope [TokenScope.read_station()]

  # defp email, do: Application.get_env(:elixatmo, :user_email)
  # defp password, do: Application.get_env(:elixatmo, :user_password)
  # defp user_data, do: %UserData{email: email(), password: password()}

  defp default_refresh_token, do: Application.get_env(:elixatmo, :default_refresh_token)

  defp app_id, do: Application.get_env(:elixatmo, :app_id)
  defp client_secret, do: Application.get_env(:elixatmo, :client_secret)
  defp app_data, do: %AppData{app_id: app_id(), client_secret: client_secret()}

  @spec get_weather() :: :error | {:ok, map()}
  def get_weather() do
    case get_access_token() do
      {:ok, access_token} -> ElixAtmo.get_stations_data(access_token)
      _ -> :error
    end
  end

  @spec get_access_token() :: :error | {:ok, String.t()}
  defp get_access_token() do
    case Cachex.get(@cache, @cache_key) do
      {:ok, nil} ->
        # with {:ok, token} <- ElixAtmo.get_access_token(user_data(), app_data(), @token_scope),
        #      {:ok, token} <- save(token) do
        #   {:ok, token.access_token}
        # else
        #   _ -> :error
        # end
        with {:ok, token} <- ElixAtmo.refresh_access_token(default_refresh_token(), app_data()),
             {:ok, token} <- save(token) do
          {:ok, token.access_token}
        else
          _ -> :error
        end

      {:ok, {token, expires_at}} ->
        case Timex.compare(expires_at, Timex.now()) do
          1 ->
            {:ok, token.access_token}

          _ ->
            with {:ok, token} <- ElixAtmo.refresh_access_token(token.refresh_token, app_data()),
                 {:ok, token} <- save(token) do
              {:ok, token.access_token}
            else
              _ -> :error
            end
        end
    end
  end

  @spec save(Token.t()) :: :error | {:ok, Token.t()}
  defp save(token) do
    expires_at = DateTimeUtil.now() |> Timex.shift(seconds: token.expires_in)

    case Cachex.put(@cache, @cache_key, {token, expires_at}) do
      {:ok, _} -> {:ok, token}
      _ -> :error
    end
  end
end
