defmodule Herenow.Products.Update do
  @moduledoc """
  Updates a product.
  """
  use Herenow.Service

  alias Herenow.Products.{Loader, Mutator}
  alias Herenow.Products.Update.Params
  alias Herenow.Core.{ErrorHandler, ErrorMessage, EctoUtils}

  def run(params) do
    with {:ok, request} <- EctoUtils.validate(Params, params),
         {:ok, product} <- Loader.find_product(request),
         {:ok, updated_product} <- Mutator.update(product, request) do
      {:ok, updated_product}
    else
      {:error, :product_not_found} ->
        ErrorMessage.not_found(:product_not_found, "Product not found")

      {:error, reason} ->
        ErrorHandler.handle(reason)
    end
  end
end
