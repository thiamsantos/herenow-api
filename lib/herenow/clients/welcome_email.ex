defmodule Herenow.Clients.WelcomeEmail do
  @moduledoc """
  Create welcome emails
  """
  alias Bamboo.Email
  alias Herenow.Clients.Storage.Client
  alias Herenow.Core.Email.Template
  alias Herenow.Core.Token
  alias Herenow.Mailer

  @spec send(%Client{}) :: Email.t()
  def send(client) do
    client
    |> create()
    |> Mailer.deliver_now()
  end

  @spec create(%Client{}) :: Email.t()
  def create(client) do
    token = Token.generate(%{"client_id" => client.id})

    body =
      Template.render(:welcome_email, %{
        "name" => client.name,
        "activation_url" => token,
        "login_url" => token,
        "email" => client.email,
        "year" => DateTime.utc_now().year
      })

    Email.new_email(
      to: {client.name, client.email},
      from: {"HereNow Contas", "contas@herenow.com.br"},
      subject: "Bem vindo #{client.name}!!!",
      html_body: body.html,
      text_body: body.text
    )
  end
end
