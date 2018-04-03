defmodule Herenow.Clients.Registration.EmailTest do
  use Herenow.DataCase
  use Bamboo.Test

  alias Herenow.{Clients, Fixtures}
  alias Herenow.Clients.Email.WelcomeEmail

  @valid_attrs Fixtures.client_attrs()

  describe "register/1" do
    test "after registering, the user gets a welcome email" do
      {:ok, client} = Clients.register(@valid_attrs)

      assert_delivered_email(WelcomeEmail.create(client))
    end
  end
end
