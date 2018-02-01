# HereNow

This is a straightforward boilerplate for building REST APIs with Elixir and Phoenix.

- Custom error handling
- Migrations
- Use dotenv or something similar for configuration
- ORM or something similar
- Logger
- Security headers
- CORS
- Coverage report tool
- Linter
- Dialyzer
- Precommit hook
- API documentation

## Configuration

Create the files `config/dev.secret.exs` and `test.secret.exs` with the following contents, filling it with your credentials.

```elixir
# config/dev.secret.exs

use Mix.Config

config :herenow,
  secret: "SECRET" # run `mix phx.gen.secret 512` to generate a secret

config :herenow, HereNow.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "USERNAME", # database username. Ex: postgres
  password: "PASSWORD", # database password. Ex: postgres
  database: "DATABASE", # database username. Ex: herenow_dev
  hostname: "HOSTNAME"  # database host.     Ex: localhost

```
```elixir
# test.secret.exs

use Mix.Config

config :herenow,
  secret: "SECRET" # run `mix phx.gen.secret 512` to generate a secret

config :herenow, HereNow.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "USERNAME", # database username. Ex: postgres
  password: "PASSWORD", # database password. Ex: postgres
  database: "DATABASE", # database username. Ex: herenow_test
  hostname: "HOSTNAME", # database host.     Ex: localhost
  pool: Ecto.Adapters.SQL.Sandbox

```

## Running

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

## Production configuration

The following environment variables must be defined:

- `HOST_NAME` - Host of the application. Ex: `api.herenow.com.br`.
- `DATABASE_HOSTNAME` - Host of the database.
- `DATABASE_USERNAME` - Username of the database.
- `DATABASE_PASSWORD` - Password of the database.
- `DATABASE_NAME` - Name of the database.
- `POOL_SIZE` - Size of the database connections pool.
- `SECRET` - Application secret key. Run the following command to generate a new one: `mix phx.gen.secret 512`.
