defmodule Herenow.Products.Show.Params do
  @moduledoc """
  Schema of a product show
  """
  use Ecto.Schema
  import Ecto.Changeset

  @fields [:client_id, :id]

  embedded_schema do
    field :client_id, :integer
  end

  @doc false
  def changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end
