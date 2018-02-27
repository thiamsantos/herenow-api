ExUnit.configure(exclude: [:recaptcha_api])
ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(Herenow.Repo, :manual)
