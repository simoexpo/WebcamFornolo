defmodule WebcamFornolo.ServiceFixtures do
  defmodule DummyAuthService do
    @behaviour WebcamFornolo.Service.Authentication.AuthProvider

    @valid_password "test"
    @valid_token "token"

    def valid_password, do: @valid_password
    def valid_token, do: @valid_token

    def authenticate(password) do
      case password do
        @valid_password -> {:ok, @valid_token}
        _ -> {:error, "Invalid password"}
      end
    end

    def is_valid?(token) do
      token == @valid_token
    end

    def invalidate(_token) do
      {:ok, true}
    end
  end

  defmodule DummyMediaService do
    defmodule SuccessImpl do
      def get_media_paginated(_page, _rpp), do: {:ok, %{total_pages: 11, items: []}}
      def save_media(_media), do: :ok
      def delete_media(_id), do: :ok
    end

    defmodule InvalidIdImpl do
      def delete_media(_id), do: :notfound
    end

    defmodule ErrorImpl do
      def get_media_paginated(_page, _rpp), do: :error
      def save_media(_media), do: :error
      def delete_media(_id), do: :error
    end
  end

  defmodule DummyWeatherService do
    defmodule SuccessImpl do
      @behaviour WebcamFornolo.Service.Weather.WeatherProvider

      alias WebcamFornolo.Model.IndoorWeatherData
      alias WebcamFornolo.Model.OutdoorWeatherData
      alias WebcamFornolo.Model.WeatherData

      @timezone "Europe/Rome"

      def get_weather_info(_provider \\ :unused) do
        {:ok,
         %WeatherData{
           indoor_weather_data: %IndoorWeatherData{
             min_temp: 7.3,
             max_temp: 8.8,
             temperature: 8.4,
             pressure: 1032.3,
             noise: 35,
             humidity: 50,
             co2: 544
           },
           outdoor_weather_data: %OutdoorWeatherData{
             min_temp: -0.2,
             max_temp: 9.3,
             temperature: 3.3,
             humidity: 76,
             rain: 0
           },
           time: Timex.from_unix(1_579_799_339, :second) |> Timex.to_datetime(@timezone)
         }}
      end
    end

    defmodule ErrorImpl do
      @behaviour WebcamFornolo.Service.Weather.WeatherProvider

      def get_weather_info(_provider \\ :unused) do
        :error
      end
    end
  end

  defmodule DummyWebcamService do
    defmodule SuccessImpl do
      @webcam_image_test "test/resources/webcam_image_test.jpg"
      def get_webcam(_id), do: {:ok, @webcam_image_test}
      def save_webcam(_id, _webcam_image), do: :ok
    end

    defmodule InvalidIdImpl do
      def get_webcam(_id), do: :notfound
      def save_webcam(_id, _webcam_image), do: :notfound
    end

    defmodule ErrorImpl do
      def get_webcam(_id), do: :error
      def save_webcam(_id, _webcam_image), do: :error
    end
  end
end
