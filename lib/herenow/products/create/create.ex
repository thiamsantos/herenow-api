defmodule Herenow.Products.Create do
  @moduledoc """
  Creates a product.
  """
  use Herenow.Service

  alias Herenow.Repo
  alias Herenow.Products.Product
  alias Herenow.Core.ErrorHandler

  def run(params) do
    with {:ok, %Product{} = product} <- create(params) do
      {:ok, product}
    else
      {:error, reason} -> ErrorHandler.handle(reason)
    end
  end

  defp create(attrs) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end
end
