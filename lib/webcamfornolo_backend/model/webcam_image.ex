defmodule WebcamfornoloBackend.Model.WebcamImage do
  @fields %{
    path: :binary,
    created_at: DateTime
  }

  use SafeExStruct
end
