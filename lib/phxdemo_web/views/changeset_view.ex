defmodule HereNowWeb.ChangesetView do
  use HereNowWeb, :view

  alias Ecto.Changeset

  @doc """
  Traverses and translates changeset errors.

  See `Ecto.Changeset.traverse_errors/2` for more details.
  """
  def render("error.json", %{changeset: changeset}) do
    %{message: "Validation failed", errors: translate_errors(changeset)}
  end

  defp translate_errors(changeset) do
    changeset
    |> Changeset.traverse_errors(&translate_error/1)
    |> Enum.flat_map(&translate_field_messages/1)
  end

  defp translate_field_messages({key, values}) do
    Enum.map(values, fn value -> %{field: key, message: value} end)
  end
end
