defmodule Herenow.Clients do
  @moduledoc """
  The Clients context.
  """
  alias Ecto.Changeset
  alias Herenow.Core.ErrorMessage
  alias Herenow.Clients.Storage.{Client, Mutator, Error, Loader}
  alias Herenow.Clients.Token
  alias Herenow.Clients.Validation
  alias Herenow.Clients.Validation.{Registration, Activation, ActivationRequest}

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
