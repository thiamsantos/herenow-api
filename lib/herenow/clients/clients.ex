defmodule Herenow.Clients do
  @moduledoc """
  The Clients context.
  """
  alias Ecto.Changeset
  alias Herenow.Core.ErrorMessage
  alias Herenow.Clients.Storage.{Client, Mutator, Error, Loader}
  alias Herenow.Clients.Token
  alias Herenow.Clients.Validation
  alias Herenow.Clients.PasswordHash

  alias Herenow.Clients.Validation.{
    Registration,
    Activation,
    ActivationRequest,
    Authentication
  }

  alias Herenow.Clients.Email.{
    WelcomeEmail,
    SuccessActivationEmail,
    RequestActivationEmail
  }

  @captcha Application.get_env(:herenow, :captcha)

  @spec register(map) :: {:ok, %Client{}} | ErrorMessage.t()
  def register(params) do
    with {:ok} <- Validation.validate(Registration, params),
         {:ok} <- @captcha.verify(params["captcha"]),
         {:ok, client} <- Mutator.create(params),
         _email <- WelcomeEmail.send(client) do
      {:ok, client}
    else
      {:error, reason} -> handle_error(reason)
    end
  end

  @spec activate(map) :: {:ok, %Client{}} | ErrorMessage.t()
  def activate(params) do
    with {:ok} <- Validation.validate(Activation, params),
         {:ok} <- @captcha.verify(params["captcha"]),
         {:ok, payload} <- Token.verify_activation_token(params["token"]),
         {:ok, verified_client} <- Mutator.verify(payload),
         client <- Loader.get!(verified_client.client_id),
         _email <- SuccessActivationEmail.send(client) do
      {:ok, client}
    else
      {:error, reason} -> handle_error(reason)
    end
  end

  @spec request_activation(map) :: {:ok, map} | ErrorMessage.t()
  def request_activation(params) do
    with {:ok} <- Validation.validate(ActivationRequest, params),
         {:ok} <- @captcha.verify(params["captcha"]),
         _email <- RequestActivationEmail.send(params["email"]) do
      {:ok, %{message: "Email successfully sended!"}}
    else
      {:error, reason} -> handle_error(reason)
    end
  end

  @spec authenticate(map) :: {:ok, map} | ErrorMessage.t()
  def authenticate(params) do
    with {:ok} <- Validation.validate(Authentication, params),
         {:ok} <- @captcha.verify(params["captcha"]),
         {:ok, token} <- do_authenticate(params) do
      {:ok, %{"token" => token}}
    else
      {:error, reason} -> handle_error(reason)
    end
  end

  defp do_authenticate(%{"email" => email, "password" => password}) do
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

  defp handle_error(reason) when is_tuple(reason), do: {:error, reason}

  defp handle_error(reason) when is_binary(reason) do
    type =
      reason
      |> String.downcase()
      |> String.replace(" ", "_")
      |> String.to_atom()

    ErrorMessage.validation(nil, type, reason)
  end

  defp handle_error(%Changeset{} = changeset) do
    changeset
    |> Error.traverse_errors()
    |> ErrorMessage.validation()
  end
end
