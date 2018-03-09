defmodule Herenow.Core.TokenTest do
  use ExUnit.Case, async: true
  alias Herenow.Core.Token

  @two_hours_seconds 2 * 60 * 60
  @secret "supersecret"
  @current_time 42
  @expiration_time 12

  describe "generate/4" do
    test "should return a valid headless jwt with two parts" do
      token = Token.generate(%{user_id: 1}, @secret, @expiration_time, @current_time)

      expected = 2

      actual =
        token
        |> String.split(".")
        |> length

      assert actual == expected
    end

    test "should return one map after decoded" do
      token = Token.generate(%{user_id: 1}, @secret, @expiration_time, @current_time)

      actual =
        token
        |> String.split(".")
        |> List.first()
        |> Base.decode64!(padding: false)
        |> Jason.decode!()

      assert is_map(actual)
    end

    test "should return a valid jwt" do
      current_time = 20
      token = Token.generate(%{user_id: 1}, @secret, @two_hours_seconds, current_time)

      expected = %{
        "user_id" => 1,
        "iat" => current_time,
        "exp" => current_time + @two_hours_seconds
      }

      assert Token.verify(token, @secret, current_time + 10) == {:ok, expected}
    end
  end

  describe "verify/3" do
    test "should return error for a invalid signature" do
      current_time = 20

      token =
        Token.generate(%{user_id: 1}, "a different secret", @two_hours_seconds, current_time)

      actual = Token.verify(token, @secret, current_time)
      expected = {:error, "Invalid signature"}

      assert actual == expected
    end

    test "should return error for a expired token" do
      current_time = 20
      token = Token.generate(%{user_id: 1}, @secret, @two_hours_seconds, current_time)

      actual = Token.verify(token, @secret, current_time + @two_hours_seconds + 1)
      expected = {:error, "Expired token"}

      assert actual == expected
    end

    test "invalid token" do
      actual = Token.verify("invalidtoken", @secret)
      expected = {:error, "Invalid signature"}

      assert actual == expected
    end
  end

  describe "get_payload/1" do
    test "should return a map with the payload" do
      payload =
        %{"client_id" => 2}
        |> Token.generate(@secret, @two_hours_seconds)
        |> Token.get_payload()

      assert is_map(payload)
    end
  end
end
