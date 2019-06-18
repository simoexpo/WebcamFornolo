defmodule WebcamfornoloBackend.Mapper.WeatherDataMapper do
  alias WebcamfornoloBackend.Model.IndoorWeatherData
  alias WebcamfornoloBackend.Model.OutdoorWeatherData
  alias WebcamfornoloBackend.Model.WeatherData

  @time "time_server"
  @timezone "Europe/Rome"

  def from(weather_data = %{}) do
    time = Timex.from_unix(Map.get(weather_data, @time)) |> Timex.to_datetime(@timezone)

    indoor_weather_data =
      Map.get(weather_data, "body")
      |> Map.get("devices")
      |> List.first()
      |> Map.get("dashboard_data", %{})
      |> map_key_to_lowercase()
      |> IndoorWeatherData.create(ignore_unknown_fields: true, allow_string_keys: true)

    outdoor_weather_data =
      Map.get(weather_data, "body")
      |> Map.get("devices")
      |> List.first()
      |> Map.get("modules")
      |> List.first()
      |> Map.get("dashboard_data", %{})
      |> map_key_to_lowercase()
      |> OutdoorWeatherData.create(
        ignore_unknown_fields: true,
        allow_string_keys: true
      )

    case {indoor_weather_data, outdoor_weather_data} do
      {{:ok, indoor_data}, {:ok, outdoor_data}} ->
        WeatherData.create(%{
          indoor_weather_data: indoor_data,
          outdoor_weather_data: outdoor_data,
          time: time
        })

      _ ->
        :error
    end
  end

  defp map_key_to_lowercase(map = %{}) do
    for {key, val} <- map, into: %{}, do: {String.downcase(key), val}
  end
end
