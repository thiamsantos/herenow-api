defmodule Herenow.Clients.UpdatePasswordTest do
  use Herenow.DataCase, async: true

  alias Herenow.Clients
  alias Faker.{Name, Address, Commerce, Internet, Company}
  alias Herenow.Clients.Storage.Mutator
  alias Herenow.Clients.PasswordHash

  @client_attrs %{
    "latitude" => Address.latitude(),
    "longitude" => Address.longitude(),
    "is_company" => true,
    "name" => Name.name(),
    "password" => "old password",
    "legal_name" => Company.name(),
    "segment" => Commerce.department(),
    "state" => Address.state(),
    "street_address" => Address.street_address(),
    "captcha" => "valid",
    "postal_code" => "12345678",
    "city" => Address.city(),
    "email" => Internet.email(),
    "lat" => Address.latitude(),
    "lon" => Address.longitude()
  }

  @valid_attrs %{
    "client_id" => 1,
    "current_password" => @client_attrs["password"],
    "password" => "new password"
  }

  def client_fixture() do
    {:ok, client} = Mutator.create(@client_attrs)

    client
  end

  describe "update_password/1" do
    test "missing keys" do
      attrs =
        @valid_attrs
        |> Map.delete("password")

      actual = Clients.update_password(attrs)

      expected =
        {:error,
         {:validation,
          [
            %{
              "field" => "password",
              "message" => "can't be blank",
              "type" => :required
            }
          ]}}

      assert actual == expected
    end

    test "invalid type of keys" do
      attrs =
        @valid_attrs
        |> Map.put("password", 9)

      actual = Clients.update_password(attrs)

      expected =
        {:error,
         {:validation,
          [
            %{
              "field" => "password",
              "message" => "is invalid",
              "type" => :cast
            }
          ]}}

      assert actual == expected
    end

    test "weak password" do
      attrs =
        @valid_attrs
        |> Map.put("password", "weak")

      actual = Clients.update_password(attrs)

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

    test "invalid current password" do
      client = client_fixture()

      attrs =
        @valid_attrs
        |> Map.put("client_id", client.id)
        |> Map.put("current_password", "invalid password")

      actual = Clients.update_password(attrs)

      expected =
        {:error,
         {:unauthorized,
          [
            %{
              "message" => "Invalid password",
              "type" => :invalid_password
            }
          ]}}

      assert actual == expected
    end

    test "not found client" do
      actual = Clients.update_password(@valid_attrs)

      expected =
        {:error,
         {:not_found,
          [
            %{
              "message" => "Client not found",
              "type" => :client_not_found
            }
          ]}}

      assert actual == expected
    end

    test "change the password" do
      client = client_fixture()

      attrs =
        @valid_attrs
        |> Map.put("client_id", client.id)

      {:ok, response} = Clients.update_password(attrs)

      assert {:ok} == PasswordHash.valid?(@valid_attrs["password"], response.password)

      assert {:error, :invalid_password} ==
               PasswordHash.valid?(@client_attrs["password"], response.password)
    end
  end
end
