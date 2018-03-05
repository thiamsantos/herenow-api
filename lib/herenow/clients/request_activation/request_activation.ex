defmodule Herenow.Clients.RequestActivation do
  @moduledoc """
  Request the activation of a client
  """
  @behaviour Herenow.Service
  use Herenow.Service

  alias Herenow.Core.{ErrorHandler, EctoUtils}
  alias Herenow.Clients.Storage.{Loader, Client}
  alias Herenow.Clients.RequestActivation.ActivationRequest
  alias Herenow.Clients.Email.{EmailNotRegistered, WelcomeEmail}

  @captcha Application.get_env(:herenow, :captcha)

  def run(params) do
    with {:ok, request} <- EctoUtils.validate(ActivationRequest, params),
         {:ok} <- @captcha.verify(request.captcha),
         _email <- send_email(request.email) do
      {:ok, %{message: "Email successfully sended!"}}
    else
      {:error, reason} -> ErrorHandler.handle(reason)
    end
  end

  defp send_email(email) do
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
