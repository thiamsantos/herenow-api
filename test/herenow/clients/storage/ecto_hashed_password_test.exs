defmodule Herenow.Clients.Storage.EctoHashedPasswordTest do
  use ExUnit.Case, async: true

  alias Herenow.Clients.Storage.EctoHashedPassword
  alias Herenow.Clients.PasswordHash

  describe "type" do
    test "should be a string" do
      assert EctoHashedPassword.type() == :string
    end
  end

  describe "cast/1" do
    test "should cast to a valid hash" do
      assert {:ok, hash} = EctoHashedPassword.cast("test_password")

      assert {:ok} == PasswordHash.valid?("test_password", hash)
      assert {:error, :invalid_password} == PasswordHash.valid?("wrong_password", hash)
    end
  end
end
