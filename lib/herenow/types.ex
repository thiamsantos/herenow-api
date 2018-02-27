Postgrex.Types.define(
  Herenow.PostgresTypes,
  [] ++ Ecto.Adapters.Postgres.extensions(),
  json: Jason
)
