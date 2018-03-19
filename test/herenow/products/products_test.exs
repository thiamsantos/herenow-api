defmodule Herenow.ProductsTest do
  use Herenow.DataCase, async: true

  alias Herenow.Products
  alias Herenow.Products.Product
  alias Faker.{Commerce, Code}

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

  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Products.create()

    product
  end

  describe "show/1" do
    test "returns the product with given id" do
      product = product_fixture()

      actual = Products.show(%{"id" => product.id})
      expected = {:ok, product}
      assert actual == expected
    end
  end

  describe "create/1" do
    test "with valid data creates a product" do
      assert {:ok, %Product{} = product} = Products.create(@valid_attrs)
      assert product.category == @valid_attrs["category"]
      assert product.code == @valid_attrs["code"]
      assert product.description == @valid_attrs["description"]
      assert product.name == @valid_attrs["name"]
      assert product.price == @valid_attrs["price"]
    end

    test "handle required fields" do
      attrs =
        @valid_attrs
        |> Map.delete("category")

      actual = Products.create(attrs)

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
    end
  end

  describe "update/1" do
    test "with valid data updates the product" do
      product = product_fixture()

      attrs =
        @update_attrs
        |> Map.put("id", product.id)

      assert {:ok, updated_product} = Products.update(attrs)
      assert updated_product.id == product.id
      assert updated_product.category == @update_attrs["category"]
      assert updated_product.code == @update_attrs["code"]
      assert updated_product.description == @update_attrs["description"]
      assert updated_product.name == @update_attrs["name"]
      assert updated_product.price == @update_attrs["price"]

      assert Products.show(%{"id" => product.id}) == {:ok, updated_product}
    end

    test "with invalid data returns error changeset" do
      product = product_fixture()

      attrs =
        @update_attrs
        |> Map.put("id", product.id)
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

  describe "list/0" do
    test "returns all products" do
      product = product_fixture()
      assert Products.list() == {:ok, [product]}
    end
  end
end
