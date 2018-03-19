defmodule Herenow.Products.Update do
  @moduledoc """
  Updates a product.
  """
  use Herenow.Service

  alias Herenow.Repo
  alias Herenow.Products.{Product, Show}
  alias Herenow.Core.ErrorHandler

  def run(params) do
    with {:ok, product} <- Show.call(params),
         {:ok, updated_product} <- update(product, params) do
      {:ok, updated_product}
    else
      {:error, reason} -> ErrorHandler.handle(reason)
    end
  end

  def update(%Product{} = product, attrs) do
    product
    |> Product.changeset(attrs)
    |> Repo.update()
  end
end
