defmodule Herenow.Clients.AuthenticationTest do
  use Herenow.DataCase, async: true

  alias Herenow.Clients
  alias Faker.{Name, Address, Commerce, Internet, Company}
  alias Herenow.Clients.Storage.Mutator

  @client_attrs %{
    "street_number" => Address.building_number(),
    "is_company" => true,
    "name" => Name.name(),
    "password" => "some password",
    "legal_name" => Company.name(),
    "segment" => Commerce.department(),
    "state" => Address.state(),
    "street_name" => Address.street_name(),
    "captcha" => "valid",
    "postal_code" => "12345678",
    "city" => Address.city(),
    "email" => Internet.email()
  }
  @valid_attrs %{
    "email" => @client_attrs["email"],
    "password" => @client_attrs["password"],
    "captcha" => "valid"
  }

  def client_fixture() do
    {:ok, client} = Mutator.create(@client_attrs)

    client
  end

  describe "authenticate/1" do
    test "missing keys" do
      attrs =
        @valid_attrs
        |> Map.delete("email")

      actual = Clients.authenticate(attrs)

      expected =
        {:error,
         {:validation,
          [
            %{
              "field" => "email",
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

        actual = Clients.authenticate(attrs)
        assert actual == expected
      end)
    end

    test "invalid captcha" do
      attrs =
        @valid_attrs
        |> Map.put("captcha", "invalid")

      actual = Clients.authenticate(attrs)

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

      actual = Clients.authenticate(attrs)

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

      actual = Clients.authenticate(attrs)

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

    test "email is not registered" do
      actual = Clients.authenticate(@valid_attrs)

      expected =
        {:error,
         {:unauthorized,
          [
            %{
              "message" => "Invalid credentials",
              "type" => :invalid_credentials
            }
          ]}}

      assert actual == expected
    end

    test "wrong password" do
      client_fixture()

      attrs =
        @valid_attrs
        |> Map.put("password", "some other password")

      actual = Clients.authenticate(attrs)

      expected =
        {:error,
         {:unauthorized,
          [
            %{
              "message" => "Invalid credentials",
              "type" => :invalid_credentials
            }
          ]}}

      assert actual == expected
    end

    test "account is not activated" do
      client_fixture()

      actual = Clients.authenticate(@valid_attrs)

      expected =
        {:error,
         {:unauthorized,
          [
            %{
              "message" => "Account not verified",
              "type" => :account_not_verified
            }
          ]}}

      assert actual == expected
    end

    test "should return a jwt with the client_id" do
      client = client_fixture()
      Mutator.verify(%{"client_id" => client.id})

      {:ok, token} = Clients.authenticate(@valid_attrs)

      actual =
        token
        |> String.split(".")
        |> List.first()
        |> Base.decode64!(padding: false)
        |> Jason.decode!()

      assert actual["client_id"] == client.id
    end

    test "should return a headless jwt" do
      client = client_fixture()
      Mutator.verify(%{"client_id" => client.id})

      {:ok, token} = Clients.authenticate(@valid_attrs)

      actual =
        token
        |> String.split(".")
        |> length()

      expected = 2

      assert actual == expected
    end

    test "should return a token with two hours of life time" do
      client = client_fixture()
      Mutator.verify(%{"client_id" => client.id})

      {:ok, token} = Clients.authenticate(@valid_attrs)

      actual =
        token
        |> String.split(".")
        |> List.first()
        |> Base.decode64!(padding: false)
        |> Jason.decode!()

      life_time = actual["exp"] - actual["iat"]

      assert life_time == 7200
    end
  end
end
