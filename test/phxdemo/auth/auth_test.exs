defmodule HereNow.AuthTest do
  use ExUnit.Case
  alias HereNow.Auth

  @two_hours_seconds  2 * 60 * 60

  describe "auth" do
    test "generate_token/1 should return a valid jwt with three parts" do
      token = Auth.generate_token(%{user_id: 1})

      expected = 3
      actual = token
      |> String.split(".")
      |> length

      assert actual == expected
    end

    test "generate_token/1 should return two maps after decoded" do
      token = Auth.generate_token(%{user_id: 1})
      actual = token
      |> String.split(".")
      |> Enum.take(2)
      |> Enum.map(&decode_token_parts/1)

      Enum.each(actual, fn part -> assert is_map(part) end)
    end

    test "generate_token/1 should return a valid jwt" do
      current_time = 20
      token = Auth.generate_token(%{user_id: 1}, current_time)

      expected = %{"user_id" => 1, "iat" => current_time, "exp" => current_time + @two_hours_seconds}

      assert Auth.verify_token(token, 30) == {:ok, expected}
    end

    test "verify_token/1 should pass down errors" do
      expected = {:error, "Some reason"}
      assert Auth.verify_token(expected) == expected
    end
  end

  defp decode_token_parts(part) do
    part
    |> Base.decode64!(padding: false)
    |> Poison.decode!()
  end
end
