defmodule Herenow.Products.Loader do
  @moduledoc """
  Database loader of product records.
  """
  alias Herenow.Repo
  alias Herenow.Products.Queries

  def find_product(request) do
    %{client_id: request.client_id, id: request.id}
    |> Queries.query_product()
    |> Repo.one()
    |> handle_product_query()
  end

  defp handle_product_query(product) when is_nil(product) do
    {:error, :product_not_found}
  end

  defp handle_product_query(product) do
    {:ok, product}
  end
end
