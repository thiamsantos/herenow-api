defmodule Herenow.Clients.Storage.EctoHashedPasswordTest do
  use Herenow.DataCase

  alias Herenow.Clients.Storage.EctoHashedPassword

  @pbkdf2_hash "$pbkdf2-sha512$160000$ez1PY1CXyWt6CZwrCEPTZg$P4iBv8Q1ora1J9LIhuyeK7EDzNeOInUim5hiRCjy9KotNWOyppyL84FmUCyX5P5ncqEQi03CmdblsbRzqu4NnA"

  describe "type" do
    test "should be a string" do
      assert EctoHashedPassword.type() == :string
    end
  end

  describe "cast/1" do
    test "should cast to a valid hash" do
      assert {:ok, hash} = EctoHashedPassword.cast("test_password")

      assert EctoHashedPassword.checkpw("test_password", hash)
      assert !EctoHashedPassword.checkpw("wrong_password", hash)
    end
  end

  describe "verify/1" do
    test "should support a pbkdf2 hash" do
      assert EctoHashedPassword.checkpw("test_password", @pbkdf2_hash)
    end
  end
end
