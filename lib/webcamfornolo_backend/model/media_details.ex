defmodule WebcamfornoloBackend.Model.MediaDetails do
  @fields %{
    id: {:number, :optional, 0},
    name: :binary,
    content_type: :binary,
    path: :binary,
    created_at: DateTime
  }

  use SafeExStruct
end
