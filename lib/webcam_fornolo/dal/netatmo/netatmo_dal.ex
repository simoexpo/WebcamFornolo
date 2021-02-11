defmodule WebcamFornolo.Dal.Netatmo.NetatmoDal do
  alias ElixAtmo.Model.UserData
  alias ElixAtmo.Model.AppData
  alias ElixAtmo.Model.TokenScope
  alias ElixAtmo.Model.Token
  alias WebcamFornolo.Util.DateTimeUtil

  @cache_key :netatmo_token
  @cache Application.compile_env!(:webcam_fornolo, :app_cache)

  @email Application.compile_env!(:elixatmo, :user_email)
  @password Application.compile_env!(:elixatmo, :user_password)
  @user_data %UserData{email: @email, password: @password}

  @app_id Application.compile_env!(:elixatmo, :app_id)
  @client_secret Application.compile_env!(:elixatmo, :client_secret)
  @app_data %AppData{app_id: @app_id, client_secret: @client_secret}

  @token_scope [TokenScope.read_station()]

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
        with {:ok, token} <- ElixAtmo.get_access_token(@user_data, @app_data, @token_scope),
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
            with {:ok, token} <- ElixAtmo.refresh_access_token(token.refresh_token, @app_data),
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
