defmodule Herenow.Clients.RequestPasswordRecovery.InvalidClientEmail do
  @moduledoc """
  Create welcome emails
  """
  alias Bamboo.Email
  alias Herenow.Core.Email.Template
  alias Herenow.Mailer

  @spec send(map) :: Email.t()
  def send(params) do
    params
    |> create()
    |> Mailer.deliver_now()
  end

  @spec create(map) :: Email.t()
  def create(params) do
    body =
      Template.render(:email_not_registered_password_recovery, %{
        "register_url" => "some url",
        "year" => DateTime.utc_now().year
      })

    Email.new_email(
      to: params.email,
      from: {"HereNow Contas", "contas@herenow.com.br"},
      subject: "Email não cadastrado!",
      html_body: body.html,
      text_body: body.text
    )
  end
end
