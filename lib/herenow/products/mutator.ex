defmodule Herenow.Products.Mutator do
  @moduledoc """
  Products database records mutator.
  """
  alias Herenow.Repo
  alias Herenow.Products.Product

  def update(%Product{} = product, attrs) do
    product
    |> Product.changeset(attrs)
    |> Repo.update()
  end
end
