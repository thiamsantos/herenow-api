defmodule Herenow.Products.ShowTest do
  use Herenow.DataCase, async: true

  alias Herenow.{Products, Fixtures}

  @valid_attrs Fixtures.product_attrs()

  describe "show/1" do
    test "returns the product with given id" do
      product = Fixtures.fixture(:product, @valid_attrs)

      actual = Products.show(%{"id" => "#{product.id}", "client_id" => product.client_id})
      expected = {:ok, product}
      assert actual == expected
    end

    test "returns not found" do
      product = Fixtures.fixture(:product, @valid_attrs)
      different_client = Fixtures.fixture(:client)

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
