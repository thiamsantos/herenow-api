defmodule Herenow.Clients.Registration.EmailTest do
  use Herenow.DataCase
  use Bamboo.Test

  alias Faker.{Name, Address, Commerce, Internet, Company}
  alias Herenow.Clients.Email.WelcomeEmail
  alias Herenow.Clients

  @valid_attrs %{
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

  describe "register/1" do
    test "after registering, the user gets a welcome email" do
      {:ok, client} = Clients.register(@valid_attrs)

      assert_delivered_email(WelcomeEmail.create(client))
    end
  end
end
