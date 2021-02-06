defmodule WebcamFornolo.DaoFixtures do
  defmodule DummyWeatherDataDao do
    defmodule SuccessImpl do
      def get_weather_data(), do: {:ok, :data}
    end

    defmodule ErrorImpl do
      def get_weather_data(), do: :error
    end
  end

  defmodule DummyMediaFileDao do
    defmodule SuccessImpl do
      alias WebcamFornolo.DataFixture
      def get(_id), do: {:ok, DataFixture.a_media_file()}

      def get_from_path_paginated(_path, _page, _rpp),
        do: {:ok, %{total_pages: 2, items: Enum.map(1..10, fn _ -> DataFixture.a_media_file() end)}}

      def save(_media, _path), do: {:ok, :data}

      def replace(_media, _path), do: {:ok, :data}

      def delete(_id), do: :ok
    end

    defmodule ErrorImpl do
      def get(_id), do: :error

      def get_from_path_paginated(_path, _page, _rpp), do: :error

      def save(_media, _path), do: :error

      def replace(_media, _path), do: :error

      def delete(_id), do: :error
    end
  end
end
