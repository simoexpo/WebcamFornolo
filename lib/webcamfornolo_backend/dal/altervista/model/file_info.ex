defmodule WebcamfornoloBackend.Dal.Altervista.Model.FileInfo do
  alias WebcamfornoloBackend.Dal.Altervista.Model.FileInfo
  alias WebcamfornoloBackend.Service.Util.DateTimeUtil

  defstruct [:file_name, :created_at]

  def from(day, month, year_or_time, file_name) do
    {year, time} =
      cond do
        year_or_time =~ ":" -> {DateTimeUtil.current_year(), year_or_time}
        true -> {year_or_time, "00:00"}
      end

    numeric_month = from_month_name_to_number(month)
    pad_day = String.pad_leading(day, 2, "0")
    date = "#{year}-#{numeric_month}-#{pad_day}T#{time}:00Z"

    case DateTime.from_iso8601(date) do
      {:ok, datetime, _} -> %FileInfo{file_name: file_name, created_at: datetime}
      _ -> :error
    end
  end

  defp from_month_name_to_number(month) do
    case month do
      "Jan" -> "01"
      "Feb" -> "02"
      "Mar" -> "03"
      "Apr" -> "04"
      "May" -> "05"
      "Jun" -> "06"
      "Jul" -> "07"
      "Aug" -> "08"
      "Sep" -> "09"
      "Oct" -> "10"
      "Nov" -> "11"
      "Dec" -> "12"
    end
  end
end
