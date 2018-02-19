use Mix.Config

config :herenow, HerenowWeb.Endpoint,
  http: [port: 4001],
  server: false

config :logger, level: :warn

config :herenow, Herenow.Mailer, adapter: Bamboo.TestAdapter

config :herenow, captcha: Herenow.Captcha.TestAdapter

config :recaptcha,
  public_key: "6LeIxAcTAAAAAJcZVRqyHh71UMIEGNQ_MXjiZKhI",
  secret: "6LeIxAcTAAAAAGG-vFI1TnRWxMZNFuojJ4WifJWe"

import_config "test.secret.exs"
