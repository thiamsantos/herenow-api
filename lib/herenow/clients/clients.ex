defmodule Herenow.Clients do
  @moduledoc """
  The Clients context.
  """
  alias Herenow.Clients.{Registration, Client, Storage, PasswordHash, WelcomeEmail}
  alias Herenow.Core.Token

  @captcha Application.get_env(:herenow, :captcha)

  # @spec register(map) :: {:ok, %Client{}} | {:error, {atom, map}}
  # def register(registration) do
  #   with {:ok} <- @captcha.verify(registration["captcha"]),
  #     {:ok} <- is_email_registered?(registration["email"]),
  #     {:ok} <- PasswordHash.verify(registration["password"]),
  #     {:ok, client} <- Storage.create_client(registration) do
  #       %{client_id: client.id}
  #       |> Token.generate()
  #       |> WelcomeEmail.create(client)
  #       |> Herenow.Mailer.deliver_now

  #       client
  #   else
  #     {:error, reason} -> handle_error(reason)
  #   end
  # end

  @spec is_email_registered?(String.t) :: {:ok} | {:error, {atom, map}}
  defp is_email_registered?(email) do
    if Storage.is_email_registered?(email) == true do
      {:ok}
    else
      {:error, {:unprocessable_entity, %{"message" => "Email already in use"}}}
    end
  end
end
