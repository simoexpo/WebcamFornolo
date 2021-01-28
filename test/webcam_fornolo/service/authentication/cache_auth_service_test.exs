defmodule WebcamFornolo.Service.Authentication.CacheAuthServiceTest do
  use ExUnit.Case

  alias WebcamFornolo.Service.Authentication.CacheAuthService

  @valid_password Application.get_env(:webcam_fornolo, :admin_password)

  test "CacheAuthService should authenticate the correct password" do
    {:ok, token} = CacheAuthService.authenticate(@valid_password)
    assert is_binary(token) == true
  end

  test "CacheAuthService should reject an invalid password" do
    assert {:error, "Invalid password"} == CacheAuthService.authenticate("invalid")
  end

  test "CacheAuthService should validate a correct token" do
    {:ok, token} = CacheAuthService.authenticate(@valid_password)
    assert CacheAuthService.is_valid?(token) == true
  end

  test "CacheAuthService should reject an invalid token" do
    assert CacheAuthService.is_valid?("random_token") == false
  end

  test "CacheAuthService should invalidate a correct token" do
    {:ok, token} = CacheAuthService.authenticate(@valid_password)
    assert CacheAuthService.is_valid?(token) == true
    {:ok, true} = CacheAuthService.invalidate(token)
    assert CacheAuthService.is_valid?(token) == false
  end
end
