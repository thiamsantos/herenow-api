use Mix.Config

config :herenow,
  ecto_repos: [Herenow.Repo]

config :herenow, HerenowWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: HerenowWeb.ErrorView, accepts: ~w(json)]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :format_encoders,
  json: Jason

config :ecto, json_library: Jason

config :herenow, Herenow.Repo, types: Herenow.PostgresTypes

import_config "#{Mix.env}.exs"
