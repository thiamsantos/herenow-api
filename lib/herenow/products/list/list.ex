defmodule Herenow.Products.List do
  @moduledoc """
  Returns the list of products.
  """
  use Herenow.Service

  alias Herenow.Repo
  alias Herenow.Products.Queries

  def run(client_id) do
    results =
      client_id
      |> Queries.all_products()
      |> Repo.all()

    {:ok, results}
  end
end
