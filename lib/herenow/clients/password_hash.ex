defmodule Herenow.Clients.PasswordHash do
  @moduledoc """
  Secure hash passwords
  """
  alias Comeonin.Pbkdf2
  alias Herenow.Core.ErrorMessage

  @spec hash(String.t) :: String.t
  def hash(password) do
    Pbkdf2.hashpwsalt(password)
  end

  @doc """
  Check password against hash with currently used hashing algorithm.
  """
  @spec verify(String.t, String.t) :: boolean
  def verify(password, hash) do
    Pbkdf2.checkpw(password, hash)
  end

  @spec is_valid(String.t) :: {:ok} | ErrorMessage.t
  def is_valid(password) when is_binary(password) do
    if String.length(password) >= 8 do
      {:ok}
    else
      ErrorMessage.create(:unprocessable_entity, "password should be at least 8 characters")
    end
  end
end
