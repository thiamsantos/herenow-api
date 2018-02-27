defmodule Herenow.Clients.Email.SuccessActivationEmail do
  @moduledoc """
  Create activation success emails
  """
  alias Bamboo.Email
  alias Herenow.Clients.Storage.Client
  alias Herenow.Core.Email.Template
  alias Herenow.Mailer

  @spec send(%Client{}) :: Email.t()
  def send(client) do
    client
    |> create()
    |> Mailer.deliver_now()
  end

  @spec create(%Client{}) :: Email.t()
  def create(client) do
    body =
      Template.render(:activation_success, %{
        "login_url" => "https://herenow.com.br/login",
        "year" => DateTime.utc_now().year
      })

    Email.new_email(
      to: {client.name, client.email},
      from: {"HereNow Contas", "contas@herenow.com.br"},
      subject: "Conta ativada com sucesso!",
      html_body: body.html,
      text_body: body.text
    )
  end
end
