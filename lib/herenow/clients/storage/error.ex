defmodule Herenow.Clients.Storage.Error do
  @moduledoc """
  Storage error handling utilities
  """

  alias Ecto.Changeset

  def traverse_errors(%Changeset{} = changeset) do
    changeset
    |> Changeset.traverse_errors(fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
    |> Enum.map(fn {k, v} -> ~s("#{k}" #{v}) end)
    |> Enum.join(", ")
  end
end
