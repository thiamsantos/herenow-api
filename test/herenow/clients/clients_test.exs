defmodule HerenowWeb.ClientsTest do
  use Herenow.DataCase
  use Bamboo.Test

  alias Faker.{Name, Address, Commerce, Internet, Company}
  alias Herenow.Clients.Storage.{Mutator, Loader}
  alias Herenow.Clients.WelcomeEmail
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
      expected = {:error, {:unprocessable_entity, ~s(Missing required keys: ["cep", "city", "email"])}}
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
          expected = {:error, {:unprocessable_entity, ~s(Expected BOOLEAN, got STRING "some string", at #{key})}}
          assert actual == expected
        else
          attrs = @valid_attrs
          |> Map.put(key, 9)

          actual = Clients.register(attrs)
          expected = {:error, {:unprocessable_entity, ~s(Expected STRING, got INTEGER 9, at #{key})}}
          assert actual == expected
        end
      end)
    end

    test "invalid captcha" do
      attrs = @valid_attrs
      |> Map.put("captcha", "invalid")

      actual = Clients.register(attrs)
      expected = {:error, {:unprocessable_entity, "Invalid captcha"}}
      assert actual == expected
    end

    test "email should be unique" do
      client = client_fixture()

      attrs = @valid_attrs
      |> Map.put("email", client.email)

      actual = Clients.register(attrs)
      expected = {:error, {:unprocessable_entity, ~s("email" has already been taken)}}
      assert actual == expected
    end

    test "email should have less than 255 characters" do
      email = @valid_attrs
      |> Map.get("email")
      |> String.pad_leading(256, "abc")

      attrs = @valid_attrs
      |> Map.put("email", email)

      actual = Clients.register(attrs)
      expected = {:error, {:unprocessable_entity, ~s'"email" should be at most 254 character(s)'}}
      assert actual == expected
    end

    test "email should have a @" do
      attrs = @valid_attrs
      |> Map.put("email", "invalidemail")

      actual = Clients.register(attrs)
      expected = {:error, {:unprocessable_entity, ~s("email" has invalid format)}}
      assert actual == expected
    end

    test "cep should have exact 8 characters, less should return error" do
      attrs = @valid_attrs
      |> Map.put("cep", "1234")

      actual = Clients.register(attrs)
      expected = {:error, {:unprocessable_entity, ~s'"cep" should be 8 character(s)'}}
      assert actual == expected
    end

    test "cep should have exact 8 characters, more should return error" do
      attrs = @valid_attrs
      |> Map.put("cep", "123456789")

      actual = Clients.register(attrs)
      expected = {:error, {:unprocessable_entity, ~s'"cep" should be 8 character(s)'}}
      assert actual == expected
    end

    test "password should have at least 8 characters" do
      attrs = @valid_attrs
      |> Map.put("password", "abcdefg")

      actual = Clients.register(attrs)
      expected = {:error, {:unprocessable_entity, ~s'"password" should be at least 8 characters'}}
      assert actual == expected
    end

    test "should return the client's information" do
      {:ok, client} = Clients.register(@valid_attrs)

      assert client.address_number == @valid_attrs["address_number"]
      assert client.cep == @valid_attrs["cep"]
      assert client.city == @valid_attrs["city"]
      assert client.email == @valid_attrs["email"]
      assert client.is_company == @valid_attrs["is_company"]
      assert client.legal_name == @valid_attrs["legal_name"]
      assert client.name == @valid_attrs["name"]
      assert client.segment == @valid_attrs["segment"]
      assert client.state == @valid_attrs["state"]
      assert client.street == @valid_attrs["street"]
    end

    test "should persist the client" do
      {:ok, client} = Clients.register(@valid_attrs)
      persisted_client = Loader.get!(client.id)

      assert client.id == persisted_client.id
      assert client.address_number == persisted_client.address_number
      assert client.cep == persisted_client.cep
      assert client.city == persisted_client.city
      assert client.email == persisted_client.email
      assert client.is_company == persisted_client.is_company
      assert client.legal_name == persisted_client.legal_name
      assert client.name == persisted_client.name
      assert client.segment == persisted_client.segment
      assert client.state == persisted_client.state
      assert client.street == persisted_client.street
      assert client.inserted_at == persisted_client.inserted_at
      assert client.updated_at == persisted_client.updated_at
    end

    test "after registering, the user gets a welcome email" do
      {:ok, client} = Clients.register(@valid_attrs)

      assert_delivered_email WelcomeEmail.create(client)
    end
  end
end
