use Mix.Config

config :phxdemo,
  ecto_repos: [Phxdemo.Repo]

config :phxdemo, PhxdemoWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: PhxdemoWeb.ErrorView, accepts: ~w(json)]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

import_config "#{Mix.env}.exs"
import_config "#{Mix.env}.secret.exs"
