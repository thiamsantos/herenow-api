defmodule HerenowWeb.ProductControllerTest do
  use HerenowWeb.ConnCase, async: true

  alias Herenow.Products
  alias Faker.{Name, Address, Commerce, Internet, Company, Code}
  alias Herenow.Clients.Storage.Mutator
  alias Herenow.Clients.Authenticate.Token
  alias HerenowWeb.AuthPlug

  @create_attrs %{
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

  defp fixture(:client) do
    attrs = %{
      "street_number" => Address.building_number(),
      "is_company" => true,
      "name" => Name.name(),
      "password" => "old password",
      "legal_name" => Company.name(),
      "segment" => Commerce.department(),
      "state" => Address.state(),
      "street_name" => Address.street_name(),
      "postal_code" => "12345678",
      "city" => Address.city(),
      "email" => Internet.email(),
      "lat" => Address.latitude(),
      "lon" => Address.longitude()
    }

    {:ok, client} = Mutator.create(attrs)
    {:ok, _verified_client} = Mutator.verify(%{"client_id" => client.id})

    client
  end

  defp fixture(:product) do
    client = fixture(:client)

    fixture(:product, client.id)
  end

  defp fixture(:product, client_id) do
    attrs =
      @create_attrs
      |> Map.put("client_id", client_id)

    {:ok, product} = Products.create(attrs)
    product
  end

  defp create_product(_) do
    product = fixture(:product)
    {:ok, product: product}
  end

  defp get_client_id(conn) do
    {:ok, token} = AuthPlug.get_token(conn)
    {:ok, claims} = Token.verify(token)

    claims["client_id"]
  end

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
      assert json_response(conn, 200) == []
    end
  end

  describe "show product" do
    setup [:create_product]

    test "renders product", %{conn: conn, product: product} do
      conn = get conn, product_path(conn, :show, product)
      product = json_response(conn, 200)

      assert is_integer(product["id"])
      assert product["category"] == @create_attrs["category"]
      assert product["code"] == @create_attrs["code"]
      assert product["description"] == @create_attrs["description"]
      assert product["name"] == @create_attrs["name"]
      assert product["price"] == @create_attrs["price"]
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
      client_id = get_client_id(conn)
      product = fixture(:product, client_id)

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
      product = fixture(:product)

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
      client_id = get_client_id(conn)

      product = fixture(:product, client_id)

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
