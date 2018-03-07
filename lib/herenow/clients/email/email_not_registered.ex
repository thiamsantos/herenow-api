defmodule Herenow.Clients.Email.EmailNotRegistered do
  @moduledoc """
  Create email not registered emails
  """
  alias Bamboo.Email
  alias Herenow.Core.Email.Template
  alias Herenow.Mailer

  @spec send(String.t()) :: Email.t()
  def send(email) do
    email
    |> create()
    |> Mailer.deliver_now()
  end

  @spec create(String.t()) :: Email.t()
  def create(email) do
    body =
      Template.render(:email_not_registered, %{
        "register_url" => "https://herenow.com.br/register",
        "year" => DateTime.utc_now().year
      })

    Email.new_email(
      to: {email},
      from: {"HereNow Contas", "contas@herenow.com.br"},
      subject: "Email não cadastrado",
      html_body: body.html,
      text_body: body.text
    )
  end
end
