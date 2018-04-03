defmodule Herenow.Elasticsearch do
  @moduledoc """
  Elasticsearch client.
  """
  @elastic_url Application.get_env(:herenow, :elastic_url)

  alias Elastix.{Mapping, Document, Search, Document, Index}

  def create_index(name) do
    Index.create(@elastic_url, name, %{})
  end

  def delete_index(name) do
    Index.delete(@elastic_url, name)
  end

  def put_mapping(index_name, doc_type, mapping) do
    Mapping.put(@elastic_url, index_name, doc_type, mapping)
  end

  def put_data(index_name, doc_type, id, data) do
    Document.index(@elastic_url, index_name, doc_type, id, data)
  end

  def update_data(index_name, doc_type, id, data) do
    Document.update(@elastic_url, index_name, doc_type, id, data)
  end

  def get_data(index_name, doc_type, id) do
    Document.get(@elastic_url, index_name, doc_type, id)
  end

  def search(index_name, search_in, payload) do
    Search.search(@elastic_url, index_name, search_in, payload)
  end

  def delete_data(index_name, doc_type, id) do
    Document.delete(@elastic_url, index_name, doc_type, id)
  end
end
