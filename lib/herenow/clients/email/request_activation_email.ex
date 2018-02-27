defmodule Herenow.Clients.Email.RequestActivationEmail do
  @moduledoc """
  Send activation emails if client is registered
  """

  alias Herenow.Clients.Storage.{Loader, Client}
  alias Herenow.Clients.Email.{EmailNotRegistered, WelcomeEmail}

  def send(email) do
    email
    |> Loader.get_one_by_email()
    |> send_appropriate_email(email)
  end

  defp send_appropriate_email(nil, email) do
    EmailNotRegistered.send(email)
  end

  defp send_appropriate_email(%Client{} = client, _email) do
    WelcomeEmail.send(client)
  end
end
