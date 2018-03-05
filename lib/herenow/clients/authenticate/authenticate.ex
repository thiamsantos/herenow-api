defmodule Herenow.Clients.Authenticate do
  @moduledoc """
  Create an access token for a client
  """
  @behaviour Herenow.Service

  alias Herenow.Clients.Authenticate.Authentication
  alias Herenow.Core.{ErrorMessage, ErrorHandler, EctoUtils}
  alias Herenow.Clients.Storage.Loader
  alias Herenow.Clients.{Token, PasswordHash}

  @captcha Application.get_env(:herenow, :captcha)

  @spec call(map) :: {:ok, String.t()} | ErrorMessage.t()
  def call(params) do
    with {:ok, request} <- EctoUtils.validate(Authentication, params),
         {:ok} <- @captcha.verify(request.captcha),
         {:ok, token} <- do_authenticate(request) do
      {:ok, token}
    else
      {:error, reason} -> ErrorHandler.handle(reason)
    end
  end

  defp do_authenticate(%{email: email, password: password}) do
    with {:ok, client} <- Loader.get_password_by_email(email),
         {:ok} <- PasswordHash.valid?(password, client.password),
         {:ok, _client} <- Loader.is_verified?(client.id) do
      token = Token.generate_activation_token(%{"client_id" => client.id})
      {:ok, token}
    else
      {:error, :email_not_found} ->
        ErrorMessage.unauthorized(:invalid_credentials, "Invalid credentials")

      {:error, :invalid_password} ->
        ErrorMessage.unauthorized(:invalid_credentials, "Invalid credentials")

      {:error, :account_not_verified} ->
        ErrorMessage.unauthorized(:account_not_verified, "Account not verified")
    end
  end
end
