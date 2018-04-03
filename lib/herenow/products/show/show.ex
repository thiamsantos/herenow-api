defmodule Herenow.Products.Show do
  @moduledoc """
  Gets a single product.
  """
  use Herenow.Service

  alias Herenow.Products.Show.Params
  alias Herenow.Products.Loader
  alias Herenow.Core.{ErrorMessage, ErrorHandler, EctoUtils}

  def run(params) do
    with {:ok, request} <- EctoUtils.validate(Params, params),
         {:ok, product} <- Loader.find_product(request) do
      {:ok, product}
    else
      {:error, :product_not_found} ->
        ErrorMessage.not_found(:product_not_found, "Product not found")

      {:error, reason} ->
        ErrorHandler.handle(reason)
    end
  end
end
