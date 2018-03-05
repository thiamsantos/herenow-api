defmodule Herenow.Clients.PasswordHash do
  @moduledoc """
  Secure hash passwords
  """
  alias Comeonin.Pbkdf2

  @spec hash(String.t()) :: String.t()
  def hash(password) do
    Pbkdf2.hashpwsalt(password)
  end

  @doc """
  Check password against hash with currently used hashing algorithm.
  """
  @spec valid?(String.t(), String.t()) :: {:ok} | {:error, :invalid_password}
  def valid?(password, hash) do
    password
    |> Pbkdf2.checkpw(hash)
    |> handle_password_check()
  end

  def handle_password_check(true), do: {:ok}
  def handle_password_check(false), do: {:error, :invalid_password}
end
