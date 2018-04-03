defmodule Herenow.Clients.RequestPasswordRecovery.EmailTest do
  use Herenow.DataCase
  use Bamboo.Test

  alias Herenow.{Clients, Fixtures}
  alias Herenow.Clients.RequestPasswordRecovery.{InvalidClientEmail, RecoveryEmail}
  alias Herenow.Clients.Storage.{Mutator}

  @client_attrs Fixtures.client_attrs()

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
