defmodule Herenow.Clients do
  @moduledoc """
  The Clients context.
  """
  alias Herenow.Clients.WelcomeEmail
  alias Herenow.Clients.Storage.{Client, Loader, Mutator}
  alias Herenow.Core.ErrorMessage

  @captcha Application.get_env(:herenow, :captcha)

  @spec register(map) :: {:ok, %Client{}} | {:error, {atom, map}}
  def register(params) do
    with :ok <- validate_params(params),
      {:ok} <- @captcha.verify(params["captcha"]),
      {:ok} <- is_email_registered?(params["email"]),
      {:ok, client} <- Mutator.create(params),
      _email <- WelcomeEmail.send(client) do
        client
    else
      {:error, reason} -> handle_error(reason)
    end
  end

  defp handle_error(reasons) when is_list(reasons), do:
    ErrorMessage.create(:unprocessable_entity, List.first(reasons))

  defp handle_error(reason) when is_tuple(reason), do: {:error, reason}

  @spec is_email_registered?(String.t) :: {:ok} | ErrorMessage.t
  defp is_email_registered?(email) do
    if Loader.is_email_registered?(email) == true do
      {:ok}
    else
      ErrorMessage.validation("Email already in use")
    end
  end

  defp validate_params(params) when is_map(params) do
    schema = %{
      "address_number" => :string,
      "cep" => :string,
      "city" => :string,
      "email" => :string,
      "is_company" => :bool,
      "legal_name" => [:string, :not_required],
      "name" => :string,
      "password" => :string,
      "segment" => :string,
      "state" => :string,
      "street" => :string,
      "captcha" => :string
    }

    Skooma.valid?(params, schema)
  end

  defp validate_params(_) do
    ErrorMessage.validation("Invalid schema")
  end
end
