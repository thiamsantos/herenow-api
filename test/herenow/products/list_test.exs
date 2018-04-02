defmodule Herenow.Products.ListTest do
  use Herenow.DataCase, async: true

  alias Herenow.Products
  alias Faker.{Name, Address, Commerce, Internet, Company, Code}
  alias Herenow.Clients.Storage.{Mutator}

  @valid_attrs %{
    "category" => Commerce.department(),
    "code" => Code.iban(),
    "description" => Commerce.product_name(),
    "name" => Commerce.product_name_product(),
    "price" => Commerce.price()
  }

  def fixture(:client) do
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
      "email" => Internet.email(),
      "lat" => Address.latitude(),
      "lon" => Address.longitude()
    }

    {:ok, client} = Mutator.create(attrs)

    client
  end

  def fixture(:product, client_id) do
    {:ok, product} =
      @valid_attrs
      |> Map.put("client_id", client_id)
      |> Products.create()

    product
  end

  describe "list/0" do
    test "returns all products" do
      client = fixture(:client)
      product = fixture(:product, client.id)
      assert Products.list(client.id) == {:ok, [product]}
    end

    test "not returns products from other clients" do
      client = fixture(:client)
      fixture(:product, client.id)

      another_client = fixture(:client)
      assert Products.list(another_client.id) == {:ok, []}
    end
  end
end
