defmodule Herenow.Clients.RecoverPassword.EmailTest do
  use Herenow.DataCase
  use Bamboo.Test

  alias Herenow.{Clients, Fixtures}
  alias Herenow.Core.Token
  alias Herenow.Clients.UpdatePassword.SuccessEmail

  @expiration_time Application.get_env(
                     :herenow,
                     :password_recovery_expiration_time
                   )
  @secret Application.get_env(:herenow, :password_recovery_secret)
  @valid_attrs %{
    "captcha" => "valid",
    "password" => "new password",
    "token" => Token.generate(%{"client_id" => 1}, @secret, @expiration_time)
  }

  describe "recover_password/1" do
    test "after password change, the user gets an email" do
      client = Fixtures.fixture(:client, false)

      token = Token.generate(%{"client_id" => client.id}, @secret, @expiration_time)

      attrs =
        @valid_attrs
        |> Map.put("token", token)

      {:ok, client} = Clients.recover_password(attrs)

      assert_delivered_email(SuccessEmail.create(client))
    end
  end
end
