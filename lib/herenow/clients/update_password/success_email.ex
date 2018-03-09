defmodule Herenow.Clients.UpdatePassword.SuccessEmail do
  @moduledoc """
  Create success email for password update
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
      Template.render(:password_update_success, %{
        "login_url" => "some login",
        "year" => DateTime.utc_now().year
      })

    Email.new_email(
      to: {client.name, client.email},
      from: {"HereNow Contas", "contas@herenow.com.br"},
      subject: "Senha alterada com sucesso!",
      html_body: body.html,
      text_body: body.text
    )
  end
end
