defmodule Herenow.Clients.WelcomeEmailTest do
  use ExUnit.Case
  use Bamboo.Test

  alias Faker.{Name, Address, Commerce, Internet, Company}
  alias Herenow.Clients.Email.WelcomeEmail

  @client %{
    id: 1,
    latitude: Address.latitude(),
    longitude: Address.longitude(),
    is_company: true,
    name: Name.name(),
    legal_name: Company.name(),
    segment: Commerce.department(),
    state: Address.state(),
    street_address: Address.street_address(),
    postal_code: "12345678",
    city: Address.city(),
    email: Internet.email()
  }

  describe "send/1" do
    test "welcome email" do
      email = WelcomeEmail.send(@client)
      assert email.to == [{@client.name, @client.email}]
      assert email.subject == "Bem vindo #{@client.name}!!!"
      assert email.html_body =~ "ative a sua conta"
      assert email.html_body =~ "Obrigado por testar HereNow."
    end
  end
end
