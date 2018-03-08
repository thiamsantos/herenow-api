defmodule Herenow.Clients.RecoverPassword do
  @moduledoc """
  Recovers the password of a client
  """
  use Herenow.Service

  alias Herenow.Core.{EctoUtils, ErrorHandler, ErrorMessage}
  alias Herenow.Clients.Storage.Mutator, as: ClientMutator
  alias Herenow.Clients.Storage.Loader, as: ClientLoader

  alias Herenow.Clients.RecoverPassword.{
    Params,
    Token,
    Mutator,
    Loader,
    SuccessEmail
  }

  @captcha Application.get_env(:herenow, :captcha)

  def run(params) do
    with {:ok, request} <- EctoUtils.validate(Params, params),
         {:ok} <- @captcha.verify(request.captcha),
         {:ok, payload} <- Token.verify(request.token),
         {:ok, false = _was_used} <- Loader.is_token_used?(request.token),
         {:ok, client} <- update_password(payload, request),
         {:ok, _used_token} <- Mutator.store_token(request.token),
         {:ok, _verified_client} <- verify_account(client),
         _email <- SuccessEmail.send(client) do
      {:ok, client}
    else
      {:error, :used_token} -> ErrorMessage.validation(nil, :used_token, "Already used token")
      {:error, reason} -> ErrorHandler.handle(reason)
    end
  end

  defp verify_account(client) do
    client.id
    |> ClientLoader.is_verified?()
    |> handle_verified_account(client)
  end

  defp handle_verified_account({:ok, verified_client}, _client) do
    {:ok, verified_client}
  end

  defp handle_verified_account({:error, :account_not_verified}, client) do
    ClientMutator.verify(%{client_id: client.id})
  end

  defp update_password(%{"client_id" => client_id}, %{password: password}) do
    ClientMutator.update_password(client_id, password)
  end
end
