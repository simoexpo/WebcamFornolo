defmodule WebcamfornoloBackend.Service.Util.DateTimeUtil do
  @timezone "Europe/Rome"

  def now() do
    Timex.now(@timezone)
  end

  def current_year() do
    now() |> Map.get(:year)
  end
end
