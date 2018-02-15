defmodule Herenow.Clients.WelcomeEmailTest do
  use ExUnit.Case
  use Bamboo.Test

  alias Faker.{Name, Address, Commerce, Internet, Company}
  alias Herenow.Clients.WelcomeEmail

  @client %{
    id: 1,
    address_number: Address.building_number(),
    is_company: true,
    name: Name.name(),
    legal_name: Company.name(),
    segment: Commerce.department(),
    state: Address.state(),
    street: Address.street_name(),
    cep: "12345678",
    city: Address.city(),
    email: Internet.email()
  }

  describe "welcome email" do
    test "send/1" do
      email = WelcomeEmail.send(@client)
      assert email.to == [{@client.name, @client.email}]
      assert email.subject == "Bem vindo #{@client.name}!!!"
      assert email.html_body =~ "Bem vindo à HearNow"
    end
  end
end
