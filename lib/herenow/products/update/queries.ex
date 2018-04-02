defmodule Herenow.Products.Update.Queries do
  @moduledoc """
  Database queries of product update.
  """
  import Ecto.Query, warn: false
  alias Herenow.Products.Product

  def query_product(%{client_id: client_id, id: id}) do
    from p in Product,
      where: [id: ^id],
      where: [client_id: ^client_id]
  end
end
