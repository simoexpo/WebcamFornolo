defmodule WebcamfornoloBackend.Model.MediaDetails do
  @fields %{
    id: {:number, :optional, 0},
    name: :binary,
    description: {:binary, :optional, nil},
    content_type: :binary,
    path: :binary,
    created_at: DateTime
  }

  use SafeExStruct
end
