defmodule WebcamFornolo.Model.MediaFile do
  @type t() :: %__MODULE__{}

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
