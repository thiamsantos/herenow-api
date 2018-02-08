defmodule Herenow.Clients.PasswordHash do
  alias Comeonin.Pbkdf2

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

  def is_valid(password) when is_binary(password) do
    if String.length(password) >= 8 do
      {:ok}
    else
      {:error, {:unprocessable_entity, %{"message" => "password should be at least 8 characters"}}}
    end
  end
  def is_valid(_) do
    {:error}
  end
end
