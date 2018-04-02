defmodule Herenow.Products.Queries do
  @moduledoc """
  Database queries of product.
  """
  import Ecto.Query, warn: false
  alias Herenow.Products.Product

  def query_product(%{client_id: client_id, id: id}) do
    from p in Product,
      where: [id: ^id],
      where: [client_id: ^client_id]
  end

  def all_products(client_id) do
    from p in Product, where: [client_id: ^client_id]
  end
end
