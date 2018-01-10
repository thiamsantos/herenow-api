use Mix.Config

config :phxdemo, PhxdemoWeb.Endpoint,
  http: [port: 4001],
  server: false

config :logger, level: :warn
