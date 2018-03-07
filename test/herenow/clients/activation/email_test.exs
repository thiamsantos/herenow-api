defmodule Herenow.Clients.Activation.EmailTest do
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
