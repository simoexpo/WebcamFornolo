defmodule WebcamFornolo.Service.AuthService do
  @moduledoc """
  General interface for authentication service.
  """

  @doc """
  Check if a given token is valid
  """
  @callback is_valid?(String.t()) :: boolean()

  @doc """
  Authenticate with password and retrieve a valid token or get an error.
  """
  @callback authenticate(String.t()) :: {:ok, String.t()} | {:error, String.t()}

  @doc """
  Invalidate a token.
  """
  @callback invalidate(String.t()) :: {:ok, true}
end
