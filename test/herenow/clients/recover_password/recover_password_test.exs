defmodule Herenow.Clients.RecoverPasswordTest do
  use Herenow.DataCase, async: true

  alias Herenow.{Clients, Fixtures}
  alias Herenow.Core.Token
  alias Herenow.Clients.Storage.Loader
  alias Herenow.Clients.PasswordHash

  @expiration_time Application.get_env(
                     :herenow,
                     :password_recovery_expiration_time
                   )
  @secret Application.get_env(:herenow, :password_recovery_secret)

  @valid_attrs %{
    "captcha" => "valid",
    "password" => "new password",
    "token" => Token.generate(%{"client_id" => 1}, @secret, @expiration_time)
  }

  describe "recover_password/1" do
    test "missing keys" do
      attrs =
        @valid_attrs
        |> Map.delete("token")

      actual = Clients.recover_password(attrs)

      expected =
        {:error,
         {:validation,
          [
            %{
              "field" => "token",
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

        actual = Clients.recover_password(attrs)
        assert actual == expected
      end)
    end

    test "invalid captcha" do
      attrs =
        @valid_attrs
        |> Map.put("captcha", "invalid")

      actual = Clients.recover_password(attrs)

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

    test "invalid token signature" do
      attrs =
        @valid_attrs
        |> Map.put("token", "invalidtoken")

      actual = Clients.recover_password(attrs)

      expected =
        {:error,
         {:validation,
          [
            %{
              "field" => nil,
              "message" => "Invalid signature",
              "type" => :invalid_signature
            }
          ]}}

      assert actual == expected
    end

    test "expired token" do
      current_time = 1

      token = Token.generate(%{"client_id" => 1}, @secret, @expiration_time, current_time)

      attrs =
        @valid_attrs
        |> Map.put("token", token)

      actual = Clients.recover_password(attrs)

      expected =
        {:error,
         {:validation,
          [
            %{
              "field" => nil,
              "message" => "Expired token",
              "type" => :expired_token
            }
          ]}}

      assert actual == expected
    end

    test "used token" do
      client = Fixtures.fixture(:client, false)

      token = Token.generate(%{"client_id" => client.id}, @secret, @expiration_time)

      attrs =
        @valid_attrs
        |> Map.put("token", token)

      _actual = Clients.recover_password(attrs)
      actual = Clients.recover_password(attrs)

      expected =
        {:error,
         {:validation,
          [
            %{
              "field" => nil,
              "message" => "Already used token",
              "type" => :used_token
            }
          ]}}

      assert actual == expected
    end

    test "weak password" do
      attrs =
        @valid_attrs
        |> Map.put("password", "weak")

      actual = Clients.recover_password(attrs)

      expected =
        {:error,
         {:validation,
          [
            %{
              "field" => "password",
              "message" => "should be at least 8 character(s)",
              "type" => :length
            }
          ]}}

      assert actual == expected
    end

    test "change the password" do
      client = Fixtures.fixture(:client, false)

      token = Token.generate(%{"client_id" => client.id}, @secret, @expiration_time)

      attrs =
        @valid_attrs
        |> Map.put("token", token)

      {:ok, response} = Clients.recover_password(attrs)

      assert {:ok} == PasswordHash.valid?(@valid_attrs["password"], response.password)

      assert {:error, :invalid_password} ==
               PasswordHash.valid?(client.password, response.password)
    end

    test "should verify unverified accounts" do
      client = Fixtures.fixture(:client, false)

      token = Token.generate(%{"client_id" => client.id}, @secret, @expiration_time)

      attrs =
        @valid_attrs
        |> Map.put("token", token)

      {:ok, response} = Clients.recover_password(attrs)

      assert {:ok} == PasswordHash.valid?(@valid_attrs["password"], response.password)

      assert {:ok, verified_client} = Loader.is_verified?(client.id)
      assert verified_client.client_id == client.id
    end
  end
end
