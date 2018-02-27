defmodule Herenow.Clients.Validation do
  @moduledoc """
  Validate service request schemas
  """

  def validate(schema, params) when is_map(params) do
    changeset = schema.changeset(schema.__struct__, params)

    if changeset.valid? do
      {:ok}
    else
      {:error, changeset}
    end
  end
end
