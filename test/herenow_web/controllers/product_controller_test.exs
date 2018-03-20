defmodule HerenowWeb.ProductControllerTest do
  use HerenowWeb.ConnCase, async: true

  alias Herenow.Products
  alias Herenow.Products.Product
  alias Faker.{Name, Address, Commerce, Internet, Company, Code}
  alias Herenow.Clients.Storage.Mutator

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

    attrs =
      @create_attrs
      |> Map.put("client_id", client.id)

    {:ok, product} = Products.create(attrs)
    product
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
      client = fixture(:client)

      attrs =
        @create_attrs
        |> Map.put("client_id", client.id)

      conn = post conn, product_path(conn, :create), attrs
      product = json_response(conn, 201)

      assert is_integer(product["id"])
      assert product["category"] == @create_attrs["category"]
      assert product["code"] == @create_attrs["code"]
      assert product["description"] == @create_attrs["description"]
      assert product["name"] == @create_attrs["name"]
      assert product["price"] == @create_attrs["price"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      client = fixture(:client)

      attrs =
        @create_attrs
        |> Map.put("client_id", client.id)
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
    setup [:create_product]

    test "renders product when data is valid", %{conn: conn, product: %Product{id: id} = product} do
      conn = put conn, product_path(conn, :update, product), @update_attrs
      actual = json_response(conn, 200)

      expected = %{
        "id" => id,
        "category" => @update_attrs["category"],
        "code" => @update_attrs["code"],
        "description" => @update_attrs["description"],
        "name" => @update_attrs["name"],
        "price" => @update_attrs["price"]
      }

      assert actual == expected
    end

    test "renders errors when data is invalid", %{conn: conn, product: product} do
      client = fixture(:client)

      attrs =
        @create_attrs
        |> Map.put("client_id", client.id)
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

  defp create_product(_) do
    product = fixture(:product)
    {:ok, product: product}
  end
end
