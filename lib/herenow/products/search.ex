defmodule Herenow.Products.Search do
  @moduledoc """
  Handle products search.
  """
  alias Herenow.Elasticsearch

  @index_name "products"
  @type_name "product"

  def put(id, data) do
    @index_name
    |> Elasticsearch.put_data(@type_name, id, data)
    |> handle_put()
  end

  defp handle_put({:ok, %HTTPoison.Response{status_code: 201, body: body}}) do
    {:ok, body}
  end

  defp handle_put({:error, %HTTPoison.Error{id: nil, reason: :timeout}}) do
    {:error, :elastisearch_timeout}
  end

  defp handle_put({:error, _error}) do
    {:error, :elasticsearch_error}
  end
end
