defmodule Herenow.Clients.UpdatePassword do
  @moduledoc """
  Update a client's password
  """
  use Herenow.Service

  alias Herenow.Core.{EctoUtils, ErrorHandler, ErrorMessage}
  alias Herenow.Clients.Storage.{Mutator, Loader}
  alias Herenow.Clients.PasswordHash

  alias Herenow.Clients.UpdatePassword.{
    Params,
    SuccessEmail
  }

  def run(params) do
    with {:ok, request} <- EctoUtils.validate(Params, params),
         {:ok, hash} <- Loader.get_password(request.client_id),
         {:ok} <- PasswordHash.valid?(request.current_password, hash),
         {:ok, client} <- update_password(request),
         _email <- SuccessEmail.send(client) do
      {:ok, client}
    else
      {:error, :client_not_found} ->
        ErrorMessage.not_found(:client_not_found, "Client not found")

      {:error, :invalid_password} ->
        ErrorMessage.unauthorized(:invalid_password, "Invalid password")

      {:error, reason} ->
        ErrorHandler.handle(reason)
    end
  end

  defp update_password(%{password: password, client_id: client_id}) do
    Mutator.update_password(client_id, password)
  end
end
