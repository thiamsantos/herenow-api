defmodule Herenow.Products.List do
  @moduledoc """
  Returns the list of products.
  """
  use Herenow.Service

  alias Herenow.Repo
  alias Herenow.Products.Product

  def run(_) do
    {:ok, Repo.all(Product)}
  end
end
