defmodule Herenow.AccessLogs.EctoIP do
  @moduledoc """
  Implements Ecto.Type behavior for storing IP (either v4 or v6) data that originally comes as tuples.
  """

  @behaviour Ecto.Type

  @doc """
  Defines what internal database type is used.
  """
  def type, do: :string

  @doc """
  As we don't have any special casting rules, simply pass the value.
  """
  def cast(value), do: {:ok, value}

  @doc """
  Loads the IP as string from the database and coverts to a tuple.
  """
  def load(value) do
    value
    |> to_charlist()
    |> :inet.parse_address()
  end

  @doc """
  Receives IP as a tuple and converts to string. In case IP is not a tuple returns an error.
  """
  def dump(value) when is_tuple(value) do
    ip =
      value
      |> :inet.ntoa()
      |> to_string()

    {:ok, ip}
  end

  def dump(_), do: :error
end
