defmodule Herenow.Core.TokenTest do
  use ExUnit.Case
  alias Herenow.Core.Token

  @two_hours_seconds 2 * 60 * 60

  describe "auth" do
    test "generate/1 should return a valid headless jwt with two parts" do
      token = Token.generate(%{user_id: 1})

      expected = 2
      actual = token
      |> String.split(".")
      |> length

      assert actual == expected
    end

    test "generate/1 should return one map after decoded" do
      token = Token.generate(%{user_id: 1})
      actual = token
      |> String.split(".")
      |> Enum.take(1)
      |> Enum.map(&decode_token_parts/1)

      Enum.each(actual, fn part -> assert is_map(part) end)
    end

    test "generate/1 should return a valid jwt" do
      current_time = 20
      token = Token.generate(%{user_id: 1}, current_time)

      expected = %{"user_id" => 1, "iat" => current_time, "exp" => current_time + @two_hours_seconds}

      assert Token.verify(token, 30) == {:ok, expected}
    end

    test "verify/1 should pass down errors" do
      expected = {:error, "Some reason"}
      assert Token.verify(expected) == expected
    end
  end

  defp decode_token_parts(part) do
    part
    |> Base.decode64!(padding: false)
    |> Poison.decode!()
  end
end