defmodule HerenowWeb.ClientsActivationTest do
  use Herenow.DataCase
  use Bamboo.Test

  alias Herenow.Clients
  alias Herenow.Core.Token
  alias Faker.{Name, Address, Commerce, Internet, Company}
  alias Herenow.Clients.Storage.{Mutator}
  alias Herenow.Clients.Email.SuccessActivationEmail

  @expiration_time Application.get_env(
                     :herenow,
                     :account_activation_expiration_time
                   )
  @secret Application.get_env(:herenow, :account_activation_secret)
  @valid_attrs %{
    "captcha" => "valid",
    "token" => Token.generate(%{"client_id" => 1}, @secret, @expiration_time)
  }

  def client_fixture() do
    attrs = %{
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

    {:ok, client} = Mutator.create(attrs)

    client
  end

  describe "activate/1" do
    test "missing keys" do
      attrs =
        @valid_attrs
        |> Map.delete("token")

      actual = Clients.activate(attrs)

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

        actual = Clients.activate(attrs)
        assert actual == expected
      end)
    end

    test "invalid captcha" do
      attrs =
        @valid_attrs
        |> Map.put("captcha", "invalid")

      actual = Clients.activate(attrs)

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

      actual = Clients.activate(attrs)

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

      actual = Clients.activate(attrs)

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

    test "client not registered" do
      actual = Clients.activate(@valid_attrs)

      expected =
        {:error,
         {:validation,
          [
            %{
              "field" => "client_id",
              "message" => "does not exist",
              "type" => :not_exists
            }
          ]}}

      assert actual == expected
    end

    test "client cannot be activated twice" do
      client = client_fixture()

      token = Token.generate(%{"client_id" => client.id}, @secret, @expiration_time)

      attrs =
        @valid_attrs
        |> Map.put("token", token)

      Mutator.verify(%{client_id: client.id})

      actual = Clients.activate(attrs)

      expected =
        {:error,
         {:validation,
          [
            %{
              "field" => "client_id",
              "message" => "has already been taken",
              "type" => :unique
            }
          ]}}

      assert actual == expected
    end

    test "activation sucess" do
      client = client_fixture()

      token = Token.generate(%{"client_id" => client.id}, @secret, @expiration_time)

      attrs =
        @valid_attrs
        |> Map.put("token", token)

      {:ok, activated_client} = Clients.activate(attrs)

      assert client.id == activated_client.id
      assert client.street_number == activated_client.street_number
      assert client.postal_code == activated_client.postal_code
      assert client.city == activated_client.city
      assert client.email == activated_client.email
      assert client.is_company == activated_client.is_company
      assert client.legal_name == activated_client.legal_name
      assert client.name == activated_client.name
      assert client.segment == activated_client.segment
      assert client.state == activated_client.state
      assert client.street_name == activated_client.street_name
      assert client.inserted_at == activated_client.inserted_at
      assert client.updated_at == activated_client.updated_at
    end

    test "after activation, the user gets an email" do
      client = client_fixture()

      token = Token.generate(%{"client_id" => client.id}, @secret, @expiration_time)

      attrs =
        @valid_attrs
        |> Map.put("token", token)

      {:ok, client} = Clients.activate(attrs)

      assert_delivered_email(SuccessActivationEmail.create(client))
    end
  end
end
