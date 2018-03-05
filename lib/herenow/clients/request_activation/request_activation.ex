defmodule Herenow.Clients.RequestActivation do
  @moduledoc """
  Request the activation of a client
  """
  @behaviour Herenow.Service

  alias Herenow.Repo
  alias Herenow.Core.{ErrorMessage, ErrorHandler, EctoUtils}
  alias Herenow.Clients.Storage.{Loader, Client}
  alias Herenow.Clients.RequestActivation.ActivationRequest
  alias Herenow.Clients.Email.{EmailNotRegistered, WelcomeEmail}

  @captcha Application.get_env(:herenow, :captcha)

  @spec call(map) :: {:ok, map} | ErrorMessage.t()
  def call(params) do
    Repo.transaction(fn ->
      with {:ok, response} <- request_activation(params) do
        response
      else
        {:error, reason} -> Repo.rollback(reason)
      end
    end)
  end

  defp request_activation(params) do
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
