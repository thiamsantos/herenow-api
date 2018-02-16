defmodule Herenow.Clients.WelcomeEmail do
  @moduledoc """
  Create welcome emails
  """
  alias Bamboo.Email
  alias Herenow.Clients.Storage.Client
  alias Herenow.Core.Token
  alias Herenow.Mailer

  @spec send(%Client{}) :: Email.t
  def send(client) do
    %{"client_id" => client.id}
    |> Token.generate()
    |> create(client)
    |> Mailer.deliver_now
  end

  @spec create(String.t, %Client{}) :: Email.t
  defp create(token, client) do
    Email.new_email(
      to: {client.name, client.email},
      from: {"HereNow Contas", "contas@herenow.com.br"},
      subject: "Welcome!!!",
      html_body: "<strong>Welcome #{token}</strong>",
      text_body: "welcome #{token}"
    )
  end
end
