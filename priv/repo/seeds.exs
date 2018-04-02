alias Herenow.Clients.Storage.{Client, Mutator}

attrs = %{
  "street_number" => "221 B",
  "is_company" => true,
  "name" => "herenow",
  "legal_name" => "Herenow",
  "segment" => "Não sei",
  "state" => "São Paulo",
  "street_name" => "Baker street",
  "postal_code" => "01001000",
  "city" => "São Paulo",
  "lat" => 28,
  "email" => "admin@herenow.com",
  "lon" => 28,
  "password" => "toortoor"
}

{:ok, client} = Mutator.create(attrs)

{:ok, _verified_client} = Mutator.verify(%{"client_id" => client.id})
