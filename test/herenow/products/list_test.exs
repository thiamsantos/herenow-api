defmodule Herenow.Products.ListTest do
  use Herenow.DataCase, async: true

  alias Herenow.{Products, Fixtures}

  @valid_attrs Fixtures.product_attrs()

  describe "list/0" do
    test "returns all products" do
      client = Fixtures.fixture(:client)
      product = Fixtures.fixture(:product, @valid_attrs, client.id)
      assert Products.list(client.id) == {:ok, [product]}
    end

    test "not returns products from other clients" do
      client = Fixtures.fixture(:client)
      Fixtures.fixture(:product, @valid_attrs, client.id)

      another_client = Fixtures.fixture(:client)
      assert Products.list(another_client.id) == {:ok, []}
    end
  end
end
