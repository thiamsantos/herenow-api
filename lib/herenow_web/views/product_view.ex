defmodule HerenowWeb.ProductView do
  use HerenowWeb, :view

  def render("index.json", %{products: products}) do
    render_many(products, __MODULE__, "show.json")
  end

  def render("show.json", %{product: product}) do
    %{
      id: product.id,
      name: product.name,
      category: product.category,
      code: product.code,
      price: product.price,
      description: product.description
    }
  end
end
