defmodule Herenow.Clients.Activate do
  @moduledoc """
  Activate a client
  """
  @behaviour Herenow.Service
  use Herenow.Service

  alias Herenow.Core.{ErrorHandler, EctoUtils}
  alias Herenow.Clients.Storage.{Mutator, Loader}
  alias Herenow.Clients.Token
  alias Herenow.Clients.Email.SuccessActivationEmail
  alias Herenow.Clients.Activate.Activation

  @captcha Application.get_env(:herenow, :captcha)

  def run(params) do
    with {:ok, request} <- EctoUtils.validate(Activation, params),
         {:ok} <- @captcha.verify(request.captcha),
         {:ok, payload} <- Token.verify_activation_token(request.token),
         {:ok, verified_client} <- Mutator.verify(payload),
         client <- Loader.get!(verified_client.client_id),
         _email <- SuccessActivationEmail.send(client) do
      {:ok, client}
    else
      {:error, reason} -> ErrorHandler.handle(reason)
    end
  end
end
