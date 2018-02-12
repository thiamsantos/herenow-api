defmodule Herenow.Clients do
  @moduledoc """
  The Clients context.
  """
  alias Herenow.Clients.WelcomeEmail
  alias Herenow.Clients.Storage.{Client, Loader, Mutator}
  alias Herenow.Core.{Token, ErrorMessage}
  alias Herenow.Mailer

  @captcha Application.get_env(:herenow, :captcha)

  @spec register(map) :: {:ok, %Client{}} | {:error, {atom, map}}
  def register(params) do
    with :ok <- validate_params(params),
      {:ok} <- @captcha.verify(params["captcha"]),
      {:ok} <- is_email_registered?(params["email"]),
      {:ok, client} <- Mutator.create(params) do
        %{client_id: client.id}
        |> Token.generate()
        |> WelcomeEmail.create(client)
        |> Mailer.deliver_now

        client
    else
      {:error, reason} -> handle_error(reason)
    end
  end

  defp handle_error(_) do

  end

  @spec is_email_registered?(String.t) :: {:ok} | ErrorMessage.t
  defp is_email_registered?(email) do
    if Loader.is_email_registered?(email) == true do
      {:ok}
    else
      ErrorMessage.create(:unprocessable_entity, "Email already in use")
    end
  end

  defp validate_params(params) when is_map(params) do
    schema = %{
      "address_number" => :string,
      "cep" => :string,
      "city" => :string,
      "email" => :string,
      "is_company" => :boolean,
      "is_verified" => :boolean,
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
    ErrorMessage.create(:unprocessable_entity, "Invalid schema")
  end
end
