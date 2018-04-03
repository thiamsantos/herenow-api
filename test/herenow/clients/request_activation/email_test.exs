defmodule Herenow.Clients.RequestActivation.EmailTest do
  use Herenow.DataCase
  use Bamboo.Test

  alias Herenow.{Clients, Fixtures}
  alias Herenow.Clients.Email.{EmailNotRegistered, WelcomeEmail}
  alias Herenow.Clients.Storage.Mutator

  @client_attrs Fixtures.client_attrs()
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
