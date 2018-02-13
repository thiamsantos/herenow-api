use Mix.Config

config :herenow, HerenowWeb.Endpoint,
  http: [port: 4001],
  server: false

config :logger, level: :warn

config :herenow, Herenow.Mailer,
  adapter: Bamboo.TestAdapter

config :herenow,
  captcha: Herenow.Captcha.TestAdapter

import_config "test.secret.exs"
