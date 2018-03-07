# Herenow

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

## Table of Contents

- [Contributing](#contributing)
- [Configuration](#configuration)
- [Running](#running)
- [Learn more](#learn-more)
- [Production configuration](#production-configuration)

## Contributing

- Fork it!
- Clone your fork: `git clone https://github.com/<your-username>/core-api`
- Navigate to the newly cloned directory: `cd core-api`
- Create a new branch for the new feature: `git checkout -b my-new-feature`
- Make your changes.
- Commit your changes: `git commit -am 'Add some feature'`
- Push to the branch: `git push origin my-new-feature`
- Submit a pull request with full remarks documenting your changes.

After you had make a fork you will want to keep your fork up to date with the changes that may happen in this repository (upstream).

- Configure the remote for your fork: `git remote add upstream https://github.com/herenow-team/core-api.git`
- Fetch the branches and their respective commits from the upstream repository: `git fetch upstream`
- Check out your fork's local master branch: `git checkout master`
- Merge the changes from upstream/master into your local master branch. This brings your fork's master branch into sync with the upstream repository, without losing your local changes: `git merge upstream/master`

## Configuration

Create the files `config/dev.secret.exs` and `test.secret.exs` with the following contents, filling it with your credentials.

```elixir
# config/dev.secret.exs

use Mix.Config

config :herenow,
  login_secret: "SECRET", # run `mix phx.gen.secret 512` to generate a secret
  account_activation_secret: "SECRET", # run `mix phx.gen.secret 512` to generate a secret
  password_recovery_secret: "SECRET" # run `mix phx.gen.secret 512` to generate a secret

config :herenow, Herenow.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "USERNAME", # database username. Ex: postgres
  password: "PASSWORD", # database password. Ex: postgres
  database: "DATABASE", # database username. Ex: herenow_dev
  hostname: "HOSTNAME"  # database host.     Ex: localhost

config :recaptcha,
  public_key: "YOUR_RECAPTCHA_PUBLIC_KEY",
  secret: "YOUR_RECAPTCHA_SECRET_KEY"

```
```elixir
# test.secret.exs

use Mix.Config

config :herenow,
  login_secret: "SECRET", # run `mix phx.gen.secret 512` to generate a secret
  account_activation_secret: "SECRET", # run `mix phx.gen.secret 512` to generate a secret 
  password_recovery_secret: "SECRET" # run `mix phx.gen.secret 512` to generate a secret 

config :herenow, Herenow.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "USERNAME", # database username. Ex: postgres
  password: "PASSWORD", # database password. Ex: postgres
  database: "DATABASE", # database username. Ex: herenow_test
  hostname: "HOSTNAME", # database host.     Ex: localhost
  pool: Ecto.Adapters.SQL.Sandbox

```

## Running

This project uses [elixir](https://elixir-lang.org/), [node](http://nodejs.org), [npm](https://npmjs.com),[docker](https://docs.docker.com/install/) and [docker-compose](https://docs.docker.com/compose/install/#master-builds).
Go check them out if you don't have them locally installed.

To start your Phoenix server:
  * Start database with `docker-compose up`
  * Install dependencies with `mix deps.get` and `npm install`
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
- `RECAPTCHA_PUBLIC_KEY` - Recapctha public key.
- `RECAPTCHA_PRIVATE_KEY` - Recapctha private key.
- `SENDGRID_API_KEY` - SendGrid API key.

