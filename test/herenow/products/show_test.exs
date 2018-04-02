defmodule Herenow.Products.ShowTest do
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

  def fixture(:product) do
    client = fixture(:client)

    {:ok, product} =
      @valid_attrs
      |> Map.put("client_id", client.id)
      |> Products.create()

    product
  end

  describe "show/1" do
    test "returns the product with given id" do
      product = fixture(:product)

      actual = Products.show(%{"id" => "#{product.id}", "client_id" => product.client_id})
      expected = {:ok, product}
      assert actual == expected
    end

    test "returns not found" do
      product = fixture(:product)
      different_client = fixture(:client)

      actual = Products.show(%{"id" => "#{product.id}", "client_id" => different_client.id})

      expected =
        {:error,
         {:not_found,
          [
            %{
              "message" => "Product not found",
              "type" => :product_not_found
            }
          ]}}

      assert actual == expected
    end
  end
end
