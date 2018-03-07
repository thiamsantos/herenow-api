defmodule Herenow.Core.EctoUtils do
  @moduledoc """
  Storage error handling utilities
  """

  alias Ecto.Changeset

  def traverse_errors(%Changeset{} = changeset) do
    changeset
    |> Changeset.traverse_errors(fn {msg, opts} ->
      message =
        Enum.reduce(opts, msg, fn {key, value}, acc ->
          String.replace(acc, "%{#{key}}", to_string(value))
        end)

      type =
        case message do
          "has already been taken" -> :unique
          "does not exist" -> :not_exists
          _ -> opts[:validation]
        end

      %{"type" => type, "message" => message}
    end)
    |> Enum.map(fn {key, value} ->
      value
      |> List.first()
      |> Map.put("field", to_string(key))
    end)
  end

  def validate(schema, params) when is_map(params) do
    changeset = schema.changeset(params)

    handle_validity_check(changeset.valid?, changeset)
  end

  defp handle_validity_check(true = _valid, changeset) do
    {:ok, changeset.changes}
  end

  defp handle_validity_check(false = _valid, changeset), do: {:error, changeset}
end
