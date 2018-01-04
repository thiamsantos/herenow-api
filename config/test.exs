use Mix.Config

config :phxdemo, PhxdemoWeb.Endpoint,
  http: [port: 4001],
  server: false

config :logger, level: :warn

config :phxdemo, Phxdemo.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "phxdemo_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
