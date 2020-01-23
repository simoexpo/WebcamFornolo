defmodule WebcamFornolo.Util.DateTimeUtilTest do
  use ExUnit.Case

  alias WebcamFornolo.Util.DateTimeUtil

  test "DateTimeUtil should return the current DateTime in UTC" do
    past = DateTime.utc_now()
    now = DateTimeUtil.now()
    future = DateTime.utc_now()

    assert now >= now
    assert now <= future
  end

  test "DateTimeUtil should convert a DateTime to Europe/Rome time zone" do
    date_time = DateTime.utc_now()
    date_time_local = DateTimeUtil.to_local(date_time)

    assert date_time.time_zone == "Etc/UTC"
    assert date_time_local.time_zone == "Europe/Rome"
  end

  test "DateTimeUtil should return the current year" do
    date_time = DateTime.utc_now()
    current_year = DateTimeUtil.current_year()

    assert current_year == date_time.year
  end

  test "DateTimeUtil should return a DateTime from utc" do
    utc_seconds = 1579806189
    date_time = DateTimeUtil.from_utc(utc_seconds)

    assert date_time == ~U[2020-01-23 19:03:09Z]
  end
end
