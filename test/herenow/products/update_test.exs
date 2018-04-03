defmodule Herenow.Products.UpdateTest do
  use Herenow.DataCase, async: true

  alias Herenow.{Products, Fixtures}

  @valid_attrs Fixtures.product_attrs()
  @update_attrs Fixtures.product_attrs()

  describe "update/1" do
    test "with valid data updates the product" do
      product = Fixtures.fixture(:product, @valid_attrs)

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

      assert Products.show(%{"id" => "#{product.id}", "client_id" => product.client_id}) ==
               {:ok, updated_product}
    end

    test "not found when different clients tries to update" do
      product = Fixtures.fixture(:product, @valid_attrs)
      different_client = Fixtures.fixture(:client)

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
      product = Fixtures.fixture(:product, @valid_attrs)

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

      assert Products.show(%{"id" => "#{product.id}", "client_id" => product.client_id}) ==
               {:ok, product}
    end
  end
end
