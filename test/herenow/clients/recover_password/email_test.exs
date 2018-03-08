defmodule Herenow.Clients.RecoverPassword.EmailTest do
  use Herenow.DataCase
  use Bamboo.Test

  alias Herenow.Clients
  alias Herenow.Core.Token
  alias Faker.{Name, Address, Commerce, Internet, Company}
  alias Herenow.Clients.Storage.{Mutator}
  alias Herenow.Clients.RecoverPassword.SuccessEmail

  @expiration_time Application.get_env(
                     :herenow,
                     :password_recovery_expiration_time
                   )
  @secret Application.get_env(:herenow, :password_recovery_secret)
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
    "password" => "new password",
    "token" => Token.generate(%{"client_id" => 1}, @secret, @expiration_time)
  }

  def client_fixture() do
    {:ok, client} = Mutator.create(@client_attrs)

    client
  end

  describe "recover_password/1" do
    test "after password change, the user gets an email" do
      client = client_fixture()

      token = Token.generate(%{"client_id" => client.id}, @secret, @expiration_time)

      attrs =
        @valid_attrs
        |> Map.put("token", token)

      {:ok, client} = Clients.recover_password(attrs)

      assert_delivered_email(SuccessEmail.create(client))
    end
  end
end
