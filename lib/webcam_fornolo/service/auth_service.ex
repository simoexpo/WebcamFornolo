defmodule WebcamFornolo.Service.AuthService do
  use Agent

  @token_expiry_in_minutes 60

  @doc """
  Check if a token is valid.
  """
  @spec is_valid?(String.t()) :: boolean()
  def is_valid?(token)

  def is_valid?(token) do
    Cachex.exists?(cache(), token) == {:ok, true}
  end

  @doc """
  Authenticate with password and retrieve a valid token.
  """
  @spec authenticate(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def authenticate(password)

  def authenticate(password) do
    if(password == admin_password()) do
      token = UUID.uuid1()

      case Cachex.put(cache(), token, :ok, ttl: :timer.minutes(@token_expiry_in_minutes)) do
        {:ok, _} -> {:ok, token}
        _ -> {:error, "Failed to save token"}
      end
    else
      {:error, "Invalid password"}
    end
  end

  @doc """
  Invalidate current token.
  """
  @spec invalidate(String.t()) :: {:ok, true}
  def invalidate(token)

  def invalidate(token) do
    Cachex.del(cache(), token)
  end

  @spec cache() :: atom
  defp cache(), do: Application.get_env(:webcamfornolo_backend, :auth_cache)

  @spec admin_password() :: String.t()
  defp admin_password, do: Application.get_env(:webcamfornolo_backend, :admin_password)
end
