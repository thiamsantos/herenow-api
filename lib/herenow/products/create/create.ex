defmodule Herenow.Products.Create do
  @moduledoc """
  Creates a product.
  """
  use Herenow.Service

  alias Herenow.Repo
  alias Herenow.Products.{Product, Search}
  alias Herenow.Core.{ErrorHandler, ErrorMessage}
  alias Herenow.Clients.Storage.Loader, as: ClientLoader

  def run(params) do
    with {:ok, %Product{} = product} <- create(params),
         {:ok, location} <- ClientLoader.get_location(product.client_id),
         {:ok, _body} <- insert_elasticsearch(product, location) do
      {:ok, product}
    else
      {:error, :elastisearch_timeout} ->
        ErrorMessage.internal(:elastisearch_timeout, "Elasticsearch Timeout")

      {:error, :elasticsearch_error} ->
        ErrorMessage.internal(:elasticsearch_error, "Elasticsearch error")

      {:error, :client_not_found} ->
        ErrorMessage.validation(nil, :invalid_client, "Invalid Client ID")

      {:error, reason} ->
        ErrorHandler.handle(reason)
    end
  end

  defp create(attrs) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end

  defp insert_elasticsearch(%Product{} = product, location) do
    Search.put(product.id, %{
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
