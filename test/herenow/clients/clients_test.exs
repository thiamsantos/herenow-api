defmodule HerenowWeb.ClientsTest do
  use Herenow.DataCase

  alias Faker.{Name, Address, Commerce, Internet, Company}
  alias Herenow.Clients.Storage.Mutator
  alias Herenow.Clients

  @valid_attrs %{
    "address_number" => Address.building_number(),
    "is_company" => true,
    "name" => Name.name(),
    "password" => "some password",
    "legal_name" => Company.name(),
    "segment" => Commerce.department(),
    "state" => Address.state(),
    "street" => Address.street_name(),
    "captcha" => "valid",
    "cep" => "12345678",
    "city" => Address.city(),
    "email" => Internet.email()
  }

  def client_fixture(attrs \\ %{}) do
    {:ok, client} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Mutator.create()

    client
  end

  describe "register/1" do
    test "missing keys" do
      attrs = @valid_attrs
      |> Map.drop(["cep", "city", "email"])

      actual = Clients.register(attrs)
      expected = {:error, {:unprocessable_entity, %{"message" => ~s(Missing required keys: ["cep", "city", "email"])}}}
      assert actual == expected
    end

    test "invalid type of keys" do
      keys = Map.keys(@valid_attrs)

      Enum.each(keys, fn key ->
        value = Map.get(@valid_attrs, key)

        if is_boolean(value) do
          attrs = @valid_attrs
          |> Map.put(key, "some string")

          actual = Clients.register(attrs)
          expected = {:error, {:unprocessable_entity, %{"message" => ~s(Expected BOOLEAN, got STRING "some string", at #{key})}}}
          assert actual == expected
        else
          attrs = @valid_attrs
          |> Map.put(key, 9)

          actual = Clients.register(attrs)
          expected = {:error, {:unprocessable_entity, %{"message" => ~s(Expected STRING, got INTEGER 9, at #{key})}}}
          assert actual == expected
        end
      end)
    end

    test "invalid captcha" do
      attrs = @valid_attrs
      |> Map.put("captcha", "invalid")

      actual = Clients.register(attrs)
      expected = {:error, {:unprocessable_entity, %{"message" => "Invalid captcha"}}}
      assert actual == expected
    end

    test "email should be unique" do
      client = client_fixture()

      attrs = @valid_attrs
      |> Map.put("email", client.email)

      actual = Clients.register(attrs)
      expected = {:error, {:unprocessable_entity, %{"message" => ~s("email" has already been taken)}}}
      assert actual == expected
    end

    test "email should have less than 255 characters" do
      email = @valid_attrs
      |> Map.get("email")
      |> String.pad_leading(256, "abc")

      attrs = @valid_attrs
      |> Map.put("email", email)

      actual = Clients.register(attrs)
      expected = {:error, {:unprocessable_entity, %{"message" => ~s'"email" should be at most 254 character(s)'}}}
      assert actual == expected
    end

    test "email should have a @" do
      attrs = @valid_attrs
      |> Map.put("email", "invalidemail")

      actual = Clients.register(attrs)
      expected = {:error, {:unprocessable_entity, %{"message" => ~s("email" has invalid format)}}}
      assert actual == expected
    end

    test "cep should have exact 8 characters, less should return error" do
      attrs = @valid_attrs
      |> Map.put("cep", "1234")

      actual = Clients.register(attrs)
      expected = {:error, {:unprocessable_entity, %{"message" => ~s'"cep" should be 8 character(s)'}}}
      assert actual == expected
    end

    test "cep should have exact 8 characters, more should return error" do
      attrs = @valid_attrs
      |> Map.put("cep", "123456789")

      actual = Clients.register(attrs)
      expected = {:error, {:unprocessable_entity, %{"message" => ~s'"cep" should be 8 character(s)'}}}
      assert actual == expected
    end

    test "password should have at least 8 characters" do
      attrs = @valid_attrs
      |> Map.put("password", "abcdefg")

      actual = Clients.register(attrs)
      expected = {:error, {:unprocessable_entity, %{"message" => ~s'"password" should be at least 8 characters'}}}
      assert actual == expected
    end
  end
end
