defmodule WebcamfornoloBackend.Service.Util.DateTimeUtil do
  @timezone "Europe/Rome"

  def now() do
    Timex.now()
  end

  def to_local(date_time = %DateTime{}) do
    Timex.Timezone.convert(date_time, @timezone)
  end

  def current_year() do
    now() |> Map.get(:year)
  end
end
