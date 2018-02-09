defmodule Herenow.Clients.EctoHashedPasswordTest do
  use Herenow.DataCase

  alias Herenow.Clients.EctoHashedPassword

  @pbkdf2_hash "$pbkdf2-sha512$160000$ez1PY1CXyWt6CZwrCEPTZg$P4iBv8Q1ora1J9LIhuyeK7EDzNeOInUim5hiRCjy9KotNWOyppyL84FmUCyX5P5ncqEQi03CmdblsbRzqu4NnA"

  describe "casting custom ecto hashed password" do
    test "type", do: assert EctoHashedPassword.type == :string

    test "cast and verify" do
      assert {:ok, hash} = EctoHashedPassword.cast("test_password")

      assert EctoHashedPassword.checkpw("test_password", hash)
      assert !EctoHashedPassword.checkpw("wrong_password", hash)
    end

    test "verify pbkdf2 hash" do
      assert EctoHashedPassword.checkpw("test_password", @pbkdf2_hash)
    end
  end
end
