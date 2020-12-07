defmodule WebcamFornolo.Util.DateTimeUtil do
  @timezone "Europe/Rome"

  @spec now() :: DateTime.t()
  def now(), do: Timex.now()

  @spec to_local(DateTime.t()) :: DateTime.t()
  def to_local(date_time = %DateTime{}), do: Timex.Timezone.convert(date_time, @timezone)

  @spec current_year() :: integer()
  def current_year(), do: now() |> Map.get(:year)

  @spec from_utc(integer(), atom()) :: DateTime.t()
  def from_utc(utc, unit \\ :second), do: Timex.from_unix(utc, unit)
end
