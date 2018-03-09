defmodule Herenow.AccessLogs.EctoIPTest do
  use ExUnit.Case, async: true

  alias Herenow.AccessLogs.EctoIP

  describe "type/0" do
    test "should be a string" do
      assert EctoIP.type() == :string
    end
  end

  describe "cast/1" do
    test "should pass the value" do
      actual = EctoIP.cast({192, 168, 0, 1})
      expected = {:ok, {192, 168, 0, 1}}

      assert actual == expected
    end
  end

  describe "dump/1" do
    test "receives an tuple ip and return an string" do
      actual = EctoIP.dump({192, 168, 0, 1})
      expected = {:ok, "192.168.0.1"}

      assert actual == expected
    end

    test "should support ipv6" do
      actual = EctoIP.dump({6553, 6553, 6553, 6553, 6553, 6553, 6553, 6553})
      expected = {:ok, "1999:1999:1999:1999:1999:1999:1999:1999"}

      assert actual == expected
    end

    test "should return for no tuple values" do
      actual = EctoIP.dump("192.168.0.1")
      expected = :error

      assert actual == expected
    end
  end

  describe "load/1" do
    test "should convert an ip string to a tuple" do
      actual = EctoIP.load("192.168.0.1")
      expected = {:ok, {192, 168, 0, 1}}

      assert actual == expected
    end

    test "should support ipv6" do
      actual = EctoIP.load("1999:1999:1999:1999:1999:1999:1999:1999")
      expected = {:ok, {6553, 6553, 6553, 6553, 6553, 6553, 6553, 6553}}

      assert actual == expected
    end
  end
end
