defmodule WebcamFornolo.ServiceFixtures do
  defmodule DummyAuthService do
    @behaviour WebcamFornolo.Service.AuthService

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
    def get_weather_info do
      {:ok, %{data1: "weather data 1", data2: "weather data 2"}}
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