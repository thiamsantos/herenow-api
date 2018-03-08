defmodule Herenow.Clients.RequestPasswordRecovery.RecoveryEmail do
  @moduledoc """
  Create welcome emails
  """
  alias Bamboo.Email
  alias Herenow.Clients.Storage.Client
  alias Herenow.Core.Email.Template
  alias Herenow.Mailer
  alias Herenow.Clients.RecoverPassword.Token

  @spec send(%Client{}, map) :: Email.t()
  def send(client, params) do
    client
    |> create(params)
    |> Mailer.deliver_now()
  end

  @spec create(%Client{}, map) :: Email.t()
  def create(client, params) do
    token = Token.generate(%{"client_id" => client.id})

    body =
      Template.render(:password_recovery, %{
        "name" => client.name,
        "password_recovery_url" => token,
        "browser_name" => params.browser_name,
        "operating_system" => params.operating_system,
        "year" => DateTime.utc_now().year
      })

    Email.new_email(
      to: {client.name, client.email},
      from: {"HereNow Contas", "contas@herenow.com.br"},
      subject: "Recuperar senha",
      html_body: body.html,
      text_body: body.text
    )
  end
end
