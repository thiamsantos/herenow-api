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
    if Pbkdf2.checkpw(password, hash) do
      {:ok}
    else
      {:error, :invalid_password}
    end
  end
end
