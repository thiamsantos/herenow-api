defmodule Herenow.Clients do
  @moduledoc """
  The Clients context.
  """
  alias Herenow.Clients.{Registration, Client, Storage}

  @captcha Application.get_env(:herenow, :captcha)

  @spec %Registration{} :: {:ok, %{Client}} | {:error, {atom, map}}
  def register(%Registration{} = registration) do
    with {:ok} <- @captcha.verify(registration.captcha),
      {:ok} <- is_email_registered?(registration.email),
      {:ok, client} <- Client.create_client(registration) do
        # TODO write ecto validations
        # TODO generate token
        # TODO send email
        client
    else
      {:error, reason} -> handle_error(reason)
    end
  end

  @spec is_email_registered?(String.t) :: {:ok} | {:error, {atom, map}}
  defp is_email_registered?(email) do
    if Storage.is_email_registered?(email) == true do
      {:ok}
    else
      {:error, {:registered_email, %{"message" => "Email already in use"}}}
    end
  end
end
