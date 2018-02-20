defmodule Herenow.Clients do
  @moduledoc """
  The Clients context.
  """
  alias Ecto.Changeset
  alias Herenow.Core.ErrorMessage
  alias Herenow.Clients.Storage.{Client, Mutator, Error}
  alias Herenow.Clients.{WelcomeEmail, Registration}

  @captcha Application.get_env(:herenow, :captcha)

  @spec register(map) :: {:ok, %Client{}} | ErrorMessage.t()
  def register(params) do
    with {:ok} <- validate_params(params),
         {:ok} <- @captcha.verify(params["captcha"]),
         {:ok, client} <- Mutator.create(params),
         _email <- WelcomeEmail.send(client) do
      {:ok, client}
    else
      {:error, reason} -> handle_error(reason)
    end
  end

  defp handle_error(reason) when is_tuple(reason), do: {:error, reason}

  defp handle_error(%Changeset{} = changeset) do
    changeset
    |> Error.traverse_errors()
    |> ErrorMessage.validation()
  end

  defp validate_params(params) when is_map(params) do
    changeset =
      %Registration{}
      |> Registration.changeset(params)

    if changeset.valid? do
      {:ok}
    else
      {:error, changeset}
    end
  end

  defp validate_params(_), do: ErrorMessage.validation(nil, :invalid_schema, "Invalid schema")
end
