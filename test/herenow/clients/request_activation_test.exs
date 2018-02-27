defmodule HerenowWeb.ClientsActivationRequestTest do
  use Herenow.DataCase
  use Bamboo.Test

  alias Herenow.Clients
  alias Herenow.Clients.Email.{EmailNotRegistered, WelcomeEmail}
  alias Faker.{Name, Address, Commerce, Internet, Company}
  alias Herenow.Clients.Storage.{Mutator}

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
    "captcha" => "valid",
    "email" => @client_attrs["email"]
  }

  def client_fixture() do
    {:ok, client} = Mutator.create(@client_attrs)

    client
  end

  describe "request_activation/1" do
    test "missing keys" do
      attrs =
        @valid_attrs
        |> Map.delete("email")

      actual = Clients.request_activation(attrs)

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

        actual = Clients.request_activation(attrs)
        assert actual == expected
      end)
    end

    test "invalid captcha" do
      attrs =
        @valid_attrs
        |> Map.put("captcha", "invalid")

      actual = Clients.request_activation(attrs)

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

      actual = Clients.request_activation(attrs)

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

      actual = Clients.request_activation(attrs)

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

    test "client not registered" do
      actual = Clients.request_activation(@valid_attrs)
      expected = {:ok, %{"message" => "Email successfully sended!"}}

      assert actual == expected
      assert_delivered_email(EmailNotRegistered.create(@valid_attrs["email"]))
    end

    test "client registered" do
      client = client_fixture()
      actual = Clients.request_activation(@valid_attrs)
      expected = {:ok, %{"message" => "Email successfully sended!"}}

      assert actual == expected
      assert_delivered_email(WelcomeEmail.create(client))
    end
  end
end
