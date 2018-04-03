defmodule HerenowWeb.ProductControllerTest do
  use HerenowWeb.ConnCase, async: true

  alias Herenow.Fixtures
  alias HerenowWeb.Helpers

  @create_attrs Fixtures.product_attrs()
  @update_attrs Fixtures.product_attrs()

  setup %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> authenticate_conn()

    {:ok, conn: conn}
  end

  describe "index" do
    test "lists all products", %{conn: conn} do
      conn = get conn, product_path(conn, :index)
      actual = json_response(conn, 200)

      assert length(actual) == 0
    end

    test "should return some products", %{conn: conn} do
      Fixtures.fixture(:product, @create_attrs, Helpers.get_client_id(conn))
      conn = get conn, product_path(conn, :index)
      actual = json_response(conn, 200)

      assert length(actual) == 1
    end

    test "should not return products from others clients", %{conn: conn} do
      Fixtures.fixture(:product, @create_attrs)
      conn = get conn, product_path(conn, :index)
      actual = json_response(conn, 200)

      assert length(actual) == 0
    end
  end

  describe "show product" do
    test "renders product", %{conn: conn} do
      product = Fixtures.fixture(:product, @create_attrs, Helpers.get_client_id(conn))
      conn = get conn, product_path(conn, :show, product)
      product = json_response(conn, 200)

      assert is_integer(product["id"])
      assert product["category"] == @create_attrs["category"]
      assert product["code"] == @create_attrs["code"]
      assert product["description"] == @create_attrs["description"]
      assert product["name"] == @create_attrs["name"]
      assert product["price"] == @create_attrs["price"]
    end

    test "client cannot see products from other clients", %{conn: conn} do
      different_client = Fixtures.fixture(:client)
      product = Fixtures.fixture(:product, @create_attrs, different_client.id)

      conn = get conn, product_path(conn, :show, product)
      actual = json_response(conn, 404)

      expected = %{
        "code" => 200,
        "errors" => [%{"code" => 201, "message" => "Product not found"}],
        "message" => "Not found!"
      }

      assert actual == expected
    end
  end

  describe "create product" do
    test "renders product when data is valid", %{conn: conn} do
      conn = post conn, product_path(conn, :create), @create_attrs
      product = json_response(conn, 201)

      assert is_integer(product["id"])
      assert product["category"] == @create_attrs["category"]
      assert product["code"] == @create_attrs["code"]
      assert product["description"] == @create_attrs["description"]
      assert product["name"] == @create_attrs["name"]
      assert product["price"] == @create_attrs["price"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      attrs =
        @create_attrs
        |> Map.delete("category")

      conn =
        conn
        |> post(product_path(conn, :create), attrs)

      actual = json_response(conn, 422)

      expected = %{
        "code" => 100,
        "message" => "Validation failed!",
        "errors" => [
          %{
            "code" => 104,
            "field" => "category",
            "message" => "can't be blank"
          }
        ]
      }

      assert actual == expected
    end
  end

  describe "update product" do
    test "renders product when data is valid", %{conn: conn} do
      client_id = Helpers.get_client_id(conn)
      product = Fixtures.fixture(:product, @create_attrs, client_id)

      conn = put conn, product_path(conn, :update, product), @update_attrs
      actual = json_response(conn, 200)

      expected = %{
        "id" => product.id,
        "category" => @update_attrs["category"],
        "code" => @update_attrs["code"],
        "description" => @update_attrs["description"],
        "name" => @update_attrs["name"],
        "price" => @update_attrs["price"]
      }

      assert actual == expected
    end

    test "not found when different clients tries to update", %{conn: conn} do
      product = Fixtures.fixture(:product, @create_attrs)

      conn = put conn, product_path(conn, :update, product), @update_attrs
      actual = json_response(conn, 404)

      expected = %{
        "code" => 200,
        "errors" => [%{"code" => 201, "message" => "Product not found"}],
        "message" => "Not found!"
      }

      assert actual == expected
    end

    test "renders errors when data is invalid", %{conn: conn} do
      client_id = Helpers.get_client_id(conn)

      product = Fixtures.fixture(:product, @create_attrs, client_id)

      attrs =
        @create_attrs
        |> Map.put("category", nil)

      conn = put conn, product_path(conn, :update, product), attrs
      actual = json_response(conn, 422)

      expected = %{
        "code" => 100,
        "errors" => [
          %{
            "code" => 104,
            "field" => "category",
            "message" => "can't be blank"
          }
        ],
        "message" => "Validation failed!"
      }

      assert actual == expected
    end
  end
end
