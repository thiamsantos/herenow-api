use Mix.Config

config :herenow,
  ecto_repos: [HereNow.Repo]

config :herenow, HereNowWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: HereNowWeb.ErrorView, accepts: ~w(json)]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

import_config "#{Mix.env}.exs"
import_config "#{Mix.env}.secret.exs"
