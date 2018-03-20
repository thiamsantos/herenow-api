defmodule Herenow.Products.Product do
  @moduledoc """
  Product schema.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @fields [:name, :category, :code, :price, :description, :client_id]

  schema "products" do
    field :category, :string
    field :code, :string
    field :description, :string
    field :name, :string
    field :price, :float
    field :client_id, :id

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> foreign_key_constraint(:client_id)
  end
end
