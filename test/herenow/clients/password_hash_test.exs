defmodule Herenow.Clients.PasswordHashTest do
  use ExUnit.Case, async: true

  alias Herenow.Clients.PasswordHash

  @pbkdf2_hash "$pbkdf2-sha512$160000$ez1PY1CXyWt6CZwrCEPTZg$P4iBv8Q1ora1J9LIhuyeK7EDzNeOInUim5hiRCjy9KotNWOyppyL84FmUCyX5P5ncqEQi03CmdblsbRzqu4NnA"

  test "hash/1 and verify/2" do
    hash = PasswordHash.hash("test_password")

    assert PasswordHash.verify("test_password", hash)
    assert !PasswordHash.verify("wrong_password", hash)
  end

  test "verify pbkdf2 hash" do
    assert PasswordHash.verify("test_password", @pbkdf2_hash)
  end

  describe "a password should have at least 8 characters" do
    test "is_valid/1 returns ok" do
      assert {:ok} = PasswordHash.is_valid("password")
    end

    test "is_valid/1 returns error" do
      assert {:error, {:unprocessable_entity, %{"message" => ~s("password" should be at least 8 characters)}}} = PasswordHash.is_valid("short")
    end
  end
end
