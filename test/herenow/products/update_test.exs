defmodule Herenow.Products.UpdateTest do
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

  @update_attrs %{
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

  describe "update/1" do
    test "with valid data updates the product" do
      product = fixture(:product)

      attrs =
        @update_attrs
        |> Map.put("client_id", product.client_id)
        |> Map.put("id", "#{product.id}")

      assert {:ok, updated_product} = Products.update(attrs)
      assert updated_product.id == product.id
      assert updated_product.category == @update_attrs["category"]
      assert updated_product.code == @update_attrs["code"]
      assert updated_product.description == @update_attrs["description"]
      assert updated_product.name == @update_attrs["name"]
      assert updated_product.price == @update_attrs["price"]

      assert Products.show(%{"id" => product.id}) == {:ok, updated_product}
    end

    test "not found when different clients tries to update" do
      product = fixture(:product)
      different_client = fixture(:client)

      attrs =
        @update_attrs
        |> Map.put("client_id", different_client.id)
        |> Map.put("id", "#{product.id}")

      actual = Products.update(attrs)

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

    test "with invalid data returns error changeset" do
      product = fixture(:product)

      attrs =
        @update_attrs
        |> Map.put("client_id", product.client_id)
        |> Map.put("id", "#{product.id}")
        |> Map.put("category", nil)

      actual = Products.update(attrs)

      expected =
        {:error,
         {:validation,
          [
            %{
              "field" => "category",
              "message" => "can't be blank",
              "type" => :required
            }
          ]}}

      assert actual == expected
      assert Products.show(%{"id" => product.id}) == {:ok, product}
    end
  end
end
