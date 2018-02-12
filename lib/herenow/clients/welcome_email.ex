defmodule Herenow.Clients.WelcomeEmail do
  @moduledoc """
  Create welcome emails
  """
  import Bamboo.Email

  def create(token, client) do
    new_email()
    |> to({client.name, client.email})
    |> from({"HereNow Contas", "contas@herenow.com.br"})
    |> subject("Welcome!!!")
    |> html_body("<strong>Welcome #{token}</strong>")
    |> text_body("welcome #{token}")
  end
end
