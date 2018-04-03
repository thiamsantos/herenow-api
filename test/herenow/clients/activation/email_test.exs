defmodule Herenow.Clients.Activation.EmailTest do
  use Herenow.DataCase
  use Bamboo.Test

  alias Herenow.{Fixtures, Clients}
  alias Herenow.Core.Token
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

  describe "activate/1" do
    test "after activation, the user gets an email" do
      client = Fixtures.fixture(:client, false)

      token = Token.generate(%{"client_id" => client.id}, @secret, @expiration_time)

      attrs =
        @valid_attrs
        |> Map.put("token", token)

      {:ok, client} = Clients.activate(attrs)

      assert_delivered_email(SuccessActivationEmail.create(client))
    end
  end
end
