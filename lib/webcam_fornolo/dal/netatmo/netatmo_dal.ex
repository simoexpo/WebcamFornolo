defmodule WebcamFornolo.Dal.Netatmo.NetatmoDal do
  alias ElixAtmo.Model.UserData
  alias ElixAtmo.Model.AppData
  alias ElixAtmo.Model.TokenScope
  alias ElixAtmo.Model.Token
  alias WebcamFornolo.Util.DateTimeUtil

  @cache_key :netatmo_token
  @token_scope [TokenScope.read_station()]

  @spec get_weather() :: :error | {:ok, map()}
  def get_weather() do
    with {:ok, access_token} <- get_access_token() do
      ElixAtmo.get_stations_data(access_token)
    else
      _ -> :error
    end
  end

  @spec get_access_token() :: :error | {:ok, String.t()}
  defp get_access_token() do
    case Cachex.get(cache(), @cache_key) do
      {:ok, nil} ->
        with {:ok, token} <- ElixAtmo.get_access_token(user_data(), app_data(), @token_scope),
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

    case Cachex.put(cache(), @cache_key, {token, expires_at}) do
      {:ok, _} -> {:ok, token}
      _ -> :error
    end
  end

  @spec user_data :: ElixAtmo.Model.UserData.t()
  defp user_data do
    email = Application.get_env(:elixatmo, :user_email)
    password = Application.get_env(:elixatmo, :user_password)
    %UserData{email: email, password: password}
  end

  @spec app_data :: ElixAtmo.Model.AppData.t()
  defp app_data do
    app_id = Application.get_env(:elixatmo, :app_id)
    client_secret = Application.get_env(:elixatmo, :client_secret)
    %AppData{app_id: app_id, client_secret: client_secret}
  end

  @spec cache() :: atom()
  defp cache(), do: Application.get_env(:webcam_fornolo, :app_cache)
end
