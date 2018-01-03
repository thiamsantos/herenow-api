defmodule PhxdemoWeb.ChangesetView do
  use PhxdemoWeb, :view

  @doc """
  Traverses and translates changeset errors.

  See `Ecto.Changeset.traverse_errors/2` and
  `PhxdemoWeb.ErrorHelpers.translate_error/1` for more details.
  """
  def render("error.json", %{changeset: changeset}) do
    %{message: "Validation failed", errors: translate_errors(changeset)}
  end

  defp translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
      |> Enum.flat_map(&translate_field_messages/1)
  end

  defp translate_field_messages({key, values}) do
    Enum.map(values, fn value -> %{field: key, message: value} end)
  end
end
