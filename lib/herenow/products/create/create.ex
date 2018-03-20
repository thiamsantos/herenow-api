defmodule Herenow.Products.Create do
  @moduledoc """
  Creates a product.
  """
  use Herenow.Service

  alias Herenow.{Repo, Elasticsearch}
  alias Herenow.Products.Product
  alias Herenow.Core.ErrorHandler
  alias Herenow.Clients.Storage.Loader, as: ClientLoader

  def run(params) do
    with {:ok, %Product{} = product} <- create(params),
         {:ok, location} <- ClientLoader.get_location(product.client_id),
         {:ok, _res} <- insert_elasticsearch(product, location) do
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

  defp insert_elasticsearch(%Product{} = product, location) do
    Elasticsearch.put_data("products", "product", product.id, %{
      category: product.category,
      description: product.description,
      name: product.name,
      price: product.price,
      client_id: product.client_id,
      location: %{lat: location.lat, lon: location.lon},
      inserted_at: product.inserted_at,
      updated_at: product.updated_at
    })
  end
end
