defmodule Herenow.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset


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
    |> cast(attrs, [:name, :category, :code, :price, :description])
    |> validate_required([:name, :category, :code, :price, :description])
  end
end
