defmodule HerenowWeb.ClientsTest do
  use ExUnit.Case

  alias Faker.{Name, Address, Commerce, Internet}
  alias Herenow.Clients

  @valid_attrs %{
    "address_number" => Address.building_number(),
    "is_company" => true,
    "name" => Name.name(),
    "password" => "some password",
    "segment" => Commerce.department(),
    "state" => Address.state(),
    "street" => Address.street_name(),
    "captcha" => "valid",
    "cep" => "12345678",
    "city" => Address.city(),
    "email" => Internet.email()
  }

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
  end
end
