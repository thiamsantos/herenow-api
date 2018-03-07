defmodule Herenow.Clients.PasswordHashTest do
  use ExUnit.Case, async: true

  alias Herenow.Clients.PasswordHash

  @pbkdf2_hash "$pbkdf2-sha512$160000$ez1PY1CXyWt6CZwrCEPTZg$P4iBv8Q1ora1J9LIhuyeK7EDzNeOInUim5hiRCjy9KotNWOyppyL84FmUCyX5P5ncqEQi03CmdblsbRzqu4NnA"

  describe "hash/1" do
    test "should produce a valid hash" do
      hash = PasswordHash.hash("test_password")

      assert {:ok} == PasswordHash.valid?("test_password", hash)
      assert {:error, :invalid_password} == PasswordHash.valid?("wrong_password", hash)
    end
  end

  describe "valid?/1" do
    test "should support a pbkdf2 hash" do
      assert PasswordHash.valid?("test_password", @pbkdf2_hash)
    end
  end
end
