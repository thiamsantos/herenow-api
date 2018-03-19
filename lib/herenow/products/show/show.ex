defmodule Herenow.Products.Show do
  @moduledoc """
  Gets a single product.
  """
  use Herenow.Service

  alias Herenow.Repo
  alias Herenow.Products.Product
  alias Herenow.Core.{ErrorMessage, ErrorHandler}

  def run(params) do
    with {:ok, product} <- show(params["id"]) do
      {:ok, product}
    else
      {:error, reason} -> ErrorHandler.handle(reason)
    end
  end

  defp show(id) do
    Product
    |> Repo.get(id)
    |> handle_show()
  end

  defp handle_show(%Product{} = product), do: {:ok, product}
  defp handle_show(nil), do: ErrorMessage.not_found(:product_not_found, "Product not , found")
end
