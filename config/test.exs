use Mix.Config

config :herenow, HerenowWeb.Endpoint,
  http: [port: 4001],
  server: false

config :logger, level: :warn

import_config "test.secret.exs"
