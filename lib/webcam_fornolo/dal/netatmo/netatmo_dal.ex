defmodule WebcamFornolo.Dal.Netatmo.NetatmoDal do
  alias ElixAtmo.Model.UserData
  alias ElixAtmo.Model.AppData
  alias ElixAtmo.Model.TokenScope
  alias WebcamFornolo.Dal.Netatmo.Model.NetatmoToken

  def user_data do
    email = Application.get_env(:elixatmo, :user_email)
    password = Application.get_env(:elixatmo, :user_password)
    %UserData{email: email, password: password}
  end

  def app_data do
    app_id = Application.get_env(:elixatmo, :app_id)
    client_secret = Application.get_env(:elixatmo, :client_secret)
    %AppData{app_id: app_id, client_secret: client_secret}
  end

  def get_access_token do
    case ElixAtmo.get_access_token(user_data(), app_data(), [TokenScope.read_station()]) do
      {:ok, raw_token} -> NetatmoToken.from(raw_token)
      :error -> :error
    end
  end

  def refresh_access_token(refresh_token) do
    case ElixAtmo.refresh_access_token(refresh_token, app_data()) do
      {:ok, raw_token} -> NetatmoToken.from(raw_token)
      :error -> :error
    end
  end

  @spec get_weather_data(String.t()) :: :error | {:ok, map()}
  def get_weather_data(access_token) do
    ElixAtmo.get_stations_data(access_token)
  end
end
