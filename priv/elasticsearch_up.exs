{:ok, _res} = Herenow.Elasticsearch.create_index("products")

mapping = %{
  properties: %{
    category: %{type: "text"},
    description: %{type: "text"},
    name: %{type: "text"},
    price: %{type: "float"},
    client_id: %{type: "integer"},
    location: %{type: "geo_point"},
    inserted_at: %{type: "date"},
    updated_at: %{type: "date"}
  }
}

{:ok, _res} = Herenow.Elasticsearch.put_mapping("products", "product", mapping)
