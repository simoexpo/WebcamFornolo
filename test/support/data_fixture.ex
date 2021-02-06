defmodule WebcamFornolo.DataFixture do
  alias WebcamFornolo.Dal.Db.MediaFileEntity
  alias WebcamFornolo.Model.MediaFile
  alias WebcamFornolo.Util.DateTimeUtil
  alias WebcamFornolo.Model.IndoorWeatherData
  alias WebcamFornolo.Model.OutdoorWeatherData
  alias WebcamFornolo.Model.WeatherData

  @timezone "Europe/Rome"
  @one_year_in_seconds 60 * 60 * 24 * 365

  @spec a_media_file :: MediaFile.t()
  def a_media_file() do
    %MediaFile{
      id: 1,
      name: "media name",
      description: "media description",
      content_type: "image",
      path: "path/to/media",
      created_at: DateTimeUtil.now()
    }
  end

  @spec a_media_file_entity :: MediaFileEntity.t()
  def a_media_file_entity() do
    %MediaFileEntity{
      name: UUID.uuid1(),
      path: "#{UUID.uuid1()}/#{UUID.uuid1()}",
      description: UUID.uuid1(),
      content_type: "jpg",
      created_at:
        DateTimeUtil.now() |> Timex.shift(seconds: :rand.uniform(@one_year_in_seconds)) |> DateTime.truncate(:second)
    }
  end

  @spec weather_data :: WeatherData.t()
  def weather_data do
    %WeatherData{
      indoor_weather_data: %IndoorWeatherData{
        co2: 429,
        humidity: 48,
        max_temp: 10,
        min_temp: 9.4,
        noise: 35,
        pressure: 1002.7,
        temperature: 9.5
      },
      outdoor_weather_data: %OutdoorWeatherData{
        humidity: 83,
        max_temp: 8.2,
        min_temp: 0.8,
        rain: 0,
        temperature: 6.7
      },
      time: Timex.from_unix(1_579_799_339, :second) |> Timex.to_datetime(@timezone)
    }
  end

  @spec weather_data_json :: map()
  def weather_data_json do
    %{
      "indoor_weather_data" => %{
        "co2" => 429,
        "humidity" => 48,
        "max_temp" => 10,
        "min_temp" => 9.4,
        "noise" => 35,
        "pressure" => 1002.7,
        "temperature" => 9.5
      },
      "outdoor_weather_data" => %{
        "humidity" => 83,
        "max_temp" => 8.2,
        "min_temp" => 0.8,
        "rain" => 0,
        "temperature" => 6.7
      },
      "time" => "2020-01-23T18:08:59+01:00"
    }
  end

  @spec raw_weather_data :: map()
  def raw_weather_data do
    %{
      "body" => %{
        "devices" => [
          %{
            "_id" => "70:ee:50:2a:e8:7e",
            "co2_calibrating" => false,
            "dashboard_data" => %{
              "AbsolutePressure" => 907.8,
              "CO2" => 429,
              "Humidity" => 48,
              "Noise" => 35,
              "Pressure" => 1002.7,
              "Temperature" => 9.5,
              "date_max_temp" => 1_611_961_477,
              "date_min_temp" => 1_612_005_627,
              "max_temp" => 10,
              "min_temp" => 9.4,
              "pressure_trend" => "down",
              "temp_trend" => "stable",
              "time_utc" => 1_612_018_932
            },
            "data_type" => ["Temperature", "CO2", "Humidity", "Noise", "Pressure"],
            "date_setup" => 1_514_559_334,
            "firmware" => 178,
            "home_id" => "5e997ae7a91a643fc71513c3",
            "home_name" => "Fornolo",
            "last_setup" => 1_514_559_334,
            "last_status_store" => 1_612_018_933,
            "last_upgrade" => 1_514_559_337,
            "module_name" => "Indoor",
            "modules" => [
              %{
                "_id" => "02:00:00:2a:e0:88",
                "battery_percent" => 60,
                "battery_vp" => 5278,
                "dashboard_data" => %{
                  "Humidity" => 83,
                  "Temperature" => 6.7,
                  "date_max_temp" => 1_611_961_435,
                  "date_min_temp" => 1_611_985_941,
                  "max_temp" => 8.2,
                  "min_temp" => 0.8,
                  "temp_trend" => "stable",
                  "time_utc" => 1_612_018_909
                },
                "data_type" => ["Temperature", "Humidity"],
                "firmware" => 50,
                "last_message" => 1_612_018_928,
                "last_seen" => 1_612_018_909,
                "last_setup" => 1_514_559_418,
                "module_name" => "Temp. Fornolo est.",
                "reachable" => true,
                "rf_status" => 77,
                "type" => "NAModule1"
              },
              %{
                "_id" => "05:00:00:06:b6:52",
                "battery_percent" => 74,
                "battery_vp" => 5422,
                "dashboard_data" => %{
                  "Rain" => 0,
                  "sum_rain_1" => 0,
                  "sum_rain_24" => 0,
                  "time_utc" => 1_612_018_921
                },
                "data_type" => ["Rain"],
                "firmware" => 12,
                "last_message" => 1_612_018_928,
                "last_seen" => 1_612_018_921,
                "last_setup" => 1_577_972_128,
                "module_name" => "Pluviometro Fornolo ",
                "reachable" => true,
                "rf_status" => 66,
                "type" => "NAModule3"
              }
            ],
            "place" => %{
              "altitude" => 831,
              "city" => "Bedonia",
              "country" => "IT",
              "location" => [9.5598453, 44.5216479],
              "timezone" => "Europe/Rome"
            },
            "reachable" => true,
            "station_name" => "Fornolo (Indoor)",
            "type" => "NAMain",
            "wifi_status" => 20
          }
        ],
        "user" => %{
          "administrative" => %{
            "country" => "IT_IT",
            "feel_like_algo" => 0,
            "lang" => "it",
            "pressureunit" => 0,
            "reg_locale" => "it-IT",
            "unit" => 0,
            "windunit" => 0
          },
          "mail" => "luciexpo@alice.it"
        }
      },
      "status" => "ok",
      "time_exec" => 0.058075904846191406,
      "time_server" => 1_579_799_339
    }
  end
end
