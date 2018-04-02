defmodule HerenowWeb.ProductController do
  use HerenowWeb, :controller

  alias Herenow.Products
  alias Herenow.Products.Product

  action_fallback(HerenowWeb.FallbackController)

  def index(conn, _params) do
    {:ok, products} = Products.list(conn.assigns[:client_id])
    render(conn, "index.json", products: products)
  end

  def create(conn, params) do
    params =
      params
      |> Map.put("client_id", conn.assigns[:client_id])

    with {:ok, %Product{} = product} <- Products.create(params) do
      conn
      |> put_status(:created)
      |> render("show.json", product: product)
    end
  end

  def show(conn, params) do
    params =
      params
      |> Map.put("client_id", conn.assigns[:client_id])

    with {:ok, product} <- Products.show(params) do
      render(conn, "show.json", product: product)
    end
  end

  def update(conn, params) do
    params =
      params
      |> Map.put("client_id", conn.assigns[:client_id])

    with {:ok, product} <- Products.update(params) do
      render(conn, "show.json", product: product)
    end
  end
end
