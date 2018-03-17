defmodule HerenowWeb.ProductControllerTest do
  use HerenowWeb.ConnCase, async: true

  alias Herenow.Products
  alias Herenow.Products.Product

  @create_attrs %{category: "some category", code: "some code", description: "some description", name: "some name", price: 120.5}
  @update_attrs %{category: "some updated category", code: "some updated code", description: "some updated description", name: "some updated name", price: 456.7}
  @invalid_attrs %{category: nil, code: nil, description: nil, name: nil, price: nil}

  def fixture(:product) do
    {:ok, product} = Products.create_product(@create_attrs)
    product
  end

  setup %{conn: conn} do
    conn = conn
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

  describe "create product" do
    test "renders product when data is valid", %{conn: conn} do
      conn = post conn, product_path(conn, :create), product: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)

      conn = get conn, product_path(conn, :show, id)
      assert json_response(conn, 200) == %{
        "id" => id,
        "category" => "some category",
        "code" => "some code",
        "description" => "some description",
        "name" => "some name",
        "price" => 120.5}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, product_path(conn, :create), product: @invalid_attrs
      assert json_response(conn, 422) != %{}
    end
  end

  describe "update product" do
    setup [:create_product]

    test "renders product when data is valid", %{conn: conn, product: %Product{id: id} = product} do
      conn = put conn, product_path(conn, :update, product), product: @update_attrs
      actual = json_response(conn, 200)

      expected = %{
        "id" => id,
        "category" => "some updated category",
        "code" => "some updated code",
        "description" => "some updated description",
        "name" => "some updated name",
        "price" => 456.7}

      assert actual == expected
    end

    test "renders errors when data is invalid", %{conn: conn, product: product} do
      conn = put conn, product_path(conn, :update, product), product: @invalid_attrs
      assert json_response(conn, 422) != %{}
    end
  end

  describe "delete product" do
    setup [:create_product]

    test "deletes chosen product", %{conn: conn, product: product} do
      conn = delete conn, product_path(conn, :delete, product)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, product_path(conn, :show, product)
      end
    end
  end

  defp create_product(_) do
    product = fixture(:product)
    {:ok, product: product}
  end
end
