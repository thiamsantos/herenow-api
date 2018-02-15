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
    client
    |> create()
    |> Mailer.deliver_now
  end

  @spec create(%Client{}) :: Email.t
  def create(client) do
    token = Token.generate(%{"client_id" => client.id})

    Email.new_email(
      to: {client.name, client.email},
      from: {"HereNow Contas", "contas@herenow.com.br"},
      subject: "Bem vindo #{client.name}!!!",
      html_body: "<strong>Bem vindo à HearNow #{token}</strong>",
      text_body: "Bem vindo à HearNow #{token}"
    )
  end
end
