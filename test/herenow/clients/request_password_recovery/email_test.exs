defmodule Herenow.Clients.RequestPasswordRecovery.EmailTest do
  use Herenow.DataCase
  use Bamboo.Test

  alias Herenow.Clients
  alias Herenow.Clients.RequestPasswordRecovery.{InvalidClientEmail, RecoveryEmail}
  alias Faker.{Name, Address, Commerce, Internet, Company}
  alias Herenow.Clients.Storage.{Mutator}

  @client_attrs %{
    "street_number" => Address.building_number(),
    "is_company" => true,
    "name" => Name.name(),
    "password" => "old password",
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
    "email" => @client_attrs["email"],
    "operating_system" => "Android",
    "browser_name" => "Firefox"
  }

  @keyword_attrs %{
    captcha: "valid",
    email: @client_attrs["email"],
    operating_system: "Android",
    browser_name: "Firefox"
  }

  def client_fixture() do
    {:ok, client} = Mutator.create(@client_attrs)
    client
  end

  describe "request_password_recovery/1" do
    test "client not registered" do
      actual = Clients.request_password_recovery(@valid_attrs)
      expected = {:ok, %{message: "Email successfully sended!"}}

      assert actual == expected

      assert_delivered_email(InvalidClientEmail.create(@keyword_attrs))
    end

    test "client registered" do
      client = client_fixture()
      actual = Clients.request_password_recovery(@valid_attrs)
      expected = {:ok, %{message: "Email successfully sended!"}}

      assert actual == expected

      assert_delivered_email(RecoveryEmail.create(client, @keyword_attrs))
    end
  end
end
