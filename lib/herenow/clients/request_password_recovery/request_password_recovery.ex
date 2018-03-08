defmodule Herenow.Clients.RequestPasswordRecovery do
  @moduledoc """
  Request a password recovery token and send via email
  """
  use Herenow.Service

  alias Herenow.Core.{EctoUtils, ErrorHandler}
  alias Herenow.Clients.Storage.Loader
  alias Herenow.Clients.Storage.Client

  alias Herenow.Clients.RequestPasswordRecovery.{
    Params,
    RecoveryEmail,
    InvalidClientEmail
  }

  @captcha Application.get_env(:herenow, :captcha)

  def run(params) do
    with {:ok, request} <- EctoUtils.validate(Params, params),
         {:ok} <- @captcha.verify(request.captcha),
         _email <- send_email(request) do
      {:ok, %{message: "Email successfully sended!"}}
    else
      {:error, reason} -> ErrorHandler.handle(reason)
    end
  end

  defp send_email(request) do
    request.email
    |> Loader.get_one_by_email()
    |> send_appropriate_email(request)
  end

  defp send_appropriate_email(nil, request) do
    InvalidClientEmail.send(request)
  end

  defp send_appropriate_email(%Client{} = client, request) do
    RecoveryEmail.send(client, request)
  end
end
