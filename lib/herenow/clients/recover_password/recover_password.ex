defmodule Herenow.Clients.RecoverPassword do
  @moduledoc """
  Recovers the password of a client
  """
  @behaviour Herenow.Service
  use Herenow.Service, captcha: true

  alias Herenow.Core.{EctoUtils, ErrorHandler, ErrorMessage}
  alias Herenow.Clients.RecoverPassword.{Params, Token, Mutator, Loader}
  alias Herenow.Clients.Storage.Mutator, as: ClientMutator

  @captcha Application.get_env(:herenow, :captcha)

  def run(params) do
    with {:ok, request} <- EctoUtils.validate(Params, params),
         {:ok} <- @captcha.verify(request.captcha),
         {:ok, payload} <- Token.verify(request.token),
         {:ok, false = _was_used} <- Loader.is_token_used?(request.token),
         {:ok, client} <- update_password(payload, request),
         {:ok, _used_token} <- Mutator.store_token(request.token) do
      {:ok, client}
    else
      {:error, :used_token} -> ErrorMessage.validation(nil, :used_token, "Already used token")
      {:error, reason} -> ErrorHandler.handle(reason)
    end
  end

  defp update_password(%{"client_id" => client_id}, %{password: password}) do
    ClientMutator.update_password(client_id, password)
  end
end
