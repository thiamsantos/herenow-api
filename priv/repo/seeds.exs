alias Herenow.Clients.Storage.{Client, Mutator}

attrs = %{
  "is_company" => true,
  "name" => "herenow",
  "legal_name" => "Herenow",
  "segment" => "Não sei",
  "state" => "São Paulo",
  "street_address" => "Baker street 221 B",
  "postal_code" => "01001000",
  "city" => "São Paulo",
  "latitude" => 28,
  "email" => "admin@herenow.com",
  "longitude" => 28,
  "password" => "toortoor"
}

{:ok, client} = Mutator.create(attrs)

{:ok, _verified_client} = Mutator.verify(%{"client_id" => client.id})
