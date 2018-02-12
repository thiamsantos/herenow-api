defmodule Herenow.Clients.Storage.EctoHashedPassword do
  @moduledoc """
  Ecto custom type for hashed passwords
  """

  @behaviour Ecto.Type

  alias Herenow.Clients.PasswordHash

  def type, do: :string

  @doc """
  Hash password with currenly used hashing algorithm
  """
  def cast(password) when is_binary(password) do
    {:ok, PasswordHash.hash(password)}
  end
  def cast(_), do: :error

  def load(password) when is_binary(password), do: {:ok, password}
  def load(_), do: :error

  def dump(password) when is_binary(password), do: {:ok, password}
  def dump(_), do: :error

  @doc """
  Check password against hash with currently used hashing algorithm.
  """
  @spec checkpw(String.t, String.t) :: boolean
  def checkpw(password, hash) do
    PasswordHash.verify(password, hash)
  end
end
