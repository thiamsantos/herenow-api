defmodule Herenow.Clients.RequestPasswordRecoveryTest do
  use Herenow.DataCase, async: true

  alias Herenow.{Clients, Fixtures}
  alias Herenow.Clients.Storage.Mutator

  @client_attrs Fixtures.client_attrs()

  @valid_attrs %{
    "captcha" => "valid",
    "email" => @client_attrs["email"],
    "operating_system" => "Android",
    "browser_name" => "Firefox"
  }

  def client_fixture() do
    {:ok, client} = Mutator.create(@client_attrs)
    client
  end

  describe "request_password_recovery/1" do
    test "missing keys" do
      attrs =
        @valid_attrs
        |> Map.delete("captcha")

      actual = Clients.request_password_recovery(attrs)

      expected =
        {:error,
         {:validation,
          [
            %{
              "field" => "captcha",
              "message" => "can't be blank",
              "type" => :required
            }
          ]}}

      assert actual == expected
    end

    test "invalid type of keys" do
      keys = Map.keys(@valid_attrs)

      Enum.each(keys, fn key ->
        expected =
          {:error,
           {:validation,
            [
              %{
                "field" => key,
                "message" => "is invalid",
                "type" => :cast
              }
            ]}}

        attrs =
          @valid_attrs
          |> Map.put(key, 9)

        actual = Clients.request_password_recovery(attrs)
        assert actual == expected
      end)
    end

    test "invalid captcha" do
      attrs =
        @valid_attrs
        |> Map.put("captcha", "invalid")

      actual = Clients.request_password_recovery(attrs)

      expected =
        {:error,
         {:validation,
          [
            %{
              "field" => nil,
              "message" => "Invalid captcha",
              "type" => :invalid_captcha
            }
          ]}}

      assert actual == expected
    end

    test "email should have less than 255 characters" do
      email =
        @valid_attrs
        |> Map.get("email")
        |> String.pad_leading(256, "abc")

      attrs =
        @valid_attrs
        |> Map.put("email", email)

      actual = Clients.request_password_recovery(attrs)

      expected =
        {:error,
         {:validation,
          [
            %{
              "field" => "email",
              "message" => "should be at most 254 character(s)",
              "type" => :length
            }
          ]}}

      assert actual == expected
    end

    test "email should have a @" do
      attrs =
        @valid_attrs
        |> Map.put("email", "invalidemail")

      actual = Clients.request_password_recovery(attrs)

      expected =
        {:error,
         {:validation,
          [
            %{
              "field" => "email",
              "message" => "has invalid format",
              "type" => :format
            }
          ]}}

      assert actual == expected
    end
  end
end
