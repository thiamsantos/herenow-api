# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :phxdemo,
  ecto_repos: [Phxdemo.Repo]

# Configures the endpoint
config :phxdemo, PhxdemoWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "WRJ+DvomxZocnX9tkvbu0q0dWY6QDeUveu211VtSH3xWOUWkCTmHMOJRJOoiFxaF",
  render_errors: [view: PhxdemoWeb.ErrorView, accepts: ~w(json)]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
