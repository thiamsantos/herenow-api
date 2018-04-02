defmodule Herenow.Products.Update do
  @moduledoc """
  Updates a product.
  """
  use Herenow.Service

  alias Herenow.Repo
  alias Herenow.Products.Product
  alias Herenow.Products.Update.{Queries, Params}
  alias Herenow.Core.{ErrorHandler, ErrorMessage, EctoUtils}

  def run(params) do
    with {:ok, request} <- EctoUtils.validate(Params, params),
         {:ok, product} <- find_product(request),
         {:ok, updated_product} <- update(product, request) do
      {:ok, updated_product}
    else
      {:error, :product_not_found} ->
        ErrorMessage.not_found(:product_not_found, "Product not found")

      {:error, reason} ->
        ErrorHandler.handle(reason)
    end
  end

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

  def update(%Product{} = product, attrs) do
    product
    |> Product.changeset(attrs)
    |> Repo.update()
  end
end
