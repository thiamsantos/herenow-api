defmodule Herenow.Products.Update.Params do
  @moduledoc """
  Schema of a product update
  """
  use Ecto.Schema
  import Ecto.Changeset

  @fields [:name, :category, :code, :price, :description, :client_id, :id]

  embedded_schema do
    field :category, :string
    field :code, :string
    field :description, :string
    field :name, :string
    field :price, :float
    field :client_id, :integer
  end

  @doc false
  def changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end
