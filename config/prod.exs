use Mix.Config

config :phxdemo, PhxdemoWeb.Endpoint,
  load_from_system_env: true,
  url: [scheme: "https", host: System.get_env("HOST_NAME"), port: 443],
  force_ssl: [rewrite_on: [:x_forwarded_proto]]

config :logger, level: :info

config :phxdemo, Phxdemo.Repo,
  adapter: Ecto.Adapters.Postgres,
  hostname: System.get_env("DATABASE_HOSTNAME"),
  username: System.get_env("DATABASE_USERNAME"),
  password: System.get_env("DATABASE_PASSWORD"),
  database: System.get_env("DATABASE_NAME"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  ssl: true

config :phxdemo,
  secret: System.get_env("SECRET")
