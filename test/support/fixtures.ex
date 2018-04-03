defmodule Herenow.Fixtures do
  alias Herenow.Products
  alias Faker.{Name, Address, Commerce, Internet, Company, Code}
  alias Herenow.Clients.Storage.Mutator

  def client_attrs do
    %{
      "captcha" => "valid",
      "street_address" => Address.street_address(),
      "latitude" => Address.latitude(),
      "longitude" => Address.longitude(),
      "is_company" => true,
      "name" => Name.name(),
      "password" => "old password",
      "legal_name" => Company.name(),
      "segment" => Commerce.department(),
      "state" => Address.state(),
      "street_name" => Address.street_name(),
      "postal_code" => "12345678",
      "city" => Address.city(),
      "email" => Internet.email()
    }
  end

  def product_attrs do
    %{
      "category" => Commerce.department(),
      "code" => Code.iban(),
      "description" => Commerce.product_name(),
      "name" => Commerce.product_name_product(),
      "price" => Commerce.price()
    }
  end

  def fixture(:client) do
    fixture(:client, true)
  end

  def fixture(:client, activate) do
    attrs = client_attrs()
    {:ok, client} = Mutator.create(attrs)

    if activate do
      {:ok, _verified_client} = Mutator.verify(%{"client_id" => client.id})
    end

    client
  end

  def fixture(:product, attrs) do
    client = fixture(:client)

    fixture(:product, attrs, client.id)
  end

  def fixture(:product, attrs, client_id) do
    attrs =
      attrs
      |> Map.put("client_id", client_id)

    {:ok, product} = Products.create(attrs)
    product
  end
end
