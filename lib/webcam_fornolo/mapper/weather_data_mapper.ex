defmodule WebcamFornolo.Mapper.WeatherDataMapper do

  alias WebcamFornolo.Model.IndoorWeatherData
  alias WebcamFornolo.Model.OutdoorWeatherData
  alias WebcamFornolo.Model.WeatherData
  alias WebcamFornolo.Util.DateTimeUtil

  @time_field "time_server"

  @spec from(map()) :: :error | {:ok, WeatherData.t}
  def from(weather_data = %{}) do
    try do
      time = DateTimeUtil.from_utc(Map.get(weather_data, @time_field)) |> DateTimeUtil.to_local

      {:ok, indoor_weather_data} =
        Map.get(weather_data, "body")
        |> Map.get("devices")
        |> List.first()
        |> Map.get("dashboard_data", %{})
        |> map_key_to_lowercase()
        |> IndoorWeatherData.create(ignore_unknown_fields: true, allow_string_keys: true)

      {:ok, outdoor_weather_data} =
        Map.get(weather_data, "body")
        |> Map.get("devices")
        |> List.first()
        |> Map.get("modules")
        |> Enum.map(fn m -> Map.get(m, "dashboard_data", %{}) end)
        |> Enum.reduce(%{}, fn x, acc -> Map.merge(acc, x) end)
        |> map_key_to_lowercase()
        |> OutdoorWeatherData.create(
          ignore_unknown_fields: true,
          allow_string_keys: true
        )

        case WeatherData.create(%{
          indoor_weather_data: indoor_weather_data,
          outdoor_weather_data: outdoor_weather_data,
          time: time
        }) do
          {:ok, value} -> {:ok, value}
          {:error, _} -> :error
        end
    rescue
      _ -> :error
    end
  end

  @spec map_key_to_lowercase(map()) :: map()
  defp map_key_to_lowercase(map = %{}) do
    for {key, val} <- map, into: %{}, do: {String.downcase(key), val}
  end
end
