defmodule Herenow.Clients.Activate do
  @moduledoc """
  Activate a client
  """
  @behaviour Herenow.Service

  alias Herenow.Core.{ErrorMessage, ErrorHandler, EctoUtils}
  alias Herenow.Clients.Storage.{Client, Mutator, Loader}
  alias Herenow.Clients.Token
  alias Herenow.Clients.Email.SuccessActivationEmail
  alias Herenow.Clients.Activate.Activation

  @captcha Application.get_env(:herenow, :captcha)

  @spec call(map) :: {:ok, %Client{}} | ErrorMessage.t()
  def call(params) do
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
