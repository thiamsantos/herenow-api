defmodule Herenow.Clients.RequestActivation.EmailTest do
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
    "email" => Internet.email(),
    "lat" => Address.latitude(),
    "lon" => Address.longitude()
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
    test "client not registered" do
      actual = Clients.request_activation(@valid_attrs)
      expected = {:ok, %{message: "Email successfully sended!"}}

      assert actual == expected
      assert_delivered_email(EmailNotRegistered.create(@valid_attrs["email"]))
    end

    test "client registered" do
      client = client_fixture()
      actual = Clients.request_activation(@valid_attrs)
      expected = {:ok, %{message: "Email successfully sended!"}}

      assert actual == expected
      assert_delivered_email(WelcomeEmail.create(client))
    end
  end
end
