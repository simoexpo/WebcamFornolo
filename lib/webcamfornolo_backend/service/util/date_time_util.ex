defmodule WebcamFornolo.Service.Util.DateTimeUtil do
  @timezone "Europe/Rome"

  def now(), do: Timex.now()

  def to_local(date_time = %DateTime{}), do: Timex.Timezone.convert(date_time, @timezone)

  def current_year(), do: now() |> Map.get(:year)

  def from_utc(utc, unit \\ :second), do: Timex.from_unix(utc, unit)
end
