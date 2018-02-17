defmodule Herenow.Clients do
  @moduledoc """
  The Clients context.
  """
  alias Ecto.Changeset
  alias Herenow.Core.ErrorMessage
  alias Herenow.Clients.Storage.{Client, Mutator, Error}
  alias Herenow.Clients.{WelcomeEmail, PasswordHash}

  @captcha Application.get_env(:herenow, :captcha)

  @spec register(map) :: {:ok, %Client{}} | ErrorMessage.t
  def register(params) do
    with :ok <- validate_params(params),
      {:ok} <- @captcha.verify(params["captcha"]),
      {:ok} <- PasswordHash.is_valid(params["password"]),
      {:ok, client} <- Mutator.create(params),
      _email <- WelcomeEmail.send(client) do
        {:ok, client}
    else
      {:error, reason} -> handle_error(reason)
    end
  end

  defp handle_error(reasons) when is_list(reasons), do:
    ErrorMessage.validation(List.first(reasons))

  defp handle_error(reason) when is_tuple(reason), do: {:error, reason}

  defp handle_error(%Changeset{} = changeset) do
    changeset
    |> Error.traverse_errors()
    |> ErrorMessage.validation()
  end

  defp validate_params(params) when is_map(params) do
    schema = %{
      "street_number" => :string,
      "postal_code" => :string,
      "city" => :string,
      "email" => :string,
      "is_company" => :bool,
      "legal_name" => [:string, :not_required],
      "name" => :string,
      "password" => :string,
      "segment" => :string,
      "state" => :string,
      "street_name" => :string,
      "captcha" => :string
    }

    Skooma.valid?(params, schema)
  end

  defp validate_params(_), do: ErrorMessage.validation("Invalid schema")
end
