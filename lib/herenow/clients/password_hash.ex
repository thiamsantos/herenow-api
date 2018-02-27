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
  @spec verify(String.t(), String.t()) :: boolean
  def verify(password, hash) do
    Pbkdf2.checkpw(password, hash)
  end
end
