defmodule Herenow.Clients.Registration.EmailTest do
  use Herenow.DataCase
  use Bamboo.Test

  alias Faker.{Name, Address, Commerce, Internet, Company}
  alias Herenow.Clients.Email.WelcomeEmail
  alias Herenow.Clients

  @valid_attrs %{
    "latitude" => Address.latitude(),
    "longitude" => Address.longitude(),
    "is_company" => true,
    "name" => Name.name(),
    "password" => "some password",
    "legal_name" => Company.name(),
    "segment" => Commerce.department(),
    "state" => Address.state(),
    "street_address" => Address.street_address(),
    "captcha" => "valid",
    "postal_code" => "12345678",
    "city" => Address.city(),
    "email" => Internet.email()
  }

  describe "register/1" do
    test "after registering, the user gets a welcome email" do
      {:ok, client} = Clients.register(@valid_attrs)

      assert_delivered_email(WelcomeEmail.create(client))
    end
  end
end
