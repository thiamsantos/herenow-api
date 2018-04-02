defmodule Herenow.Clients.Storage.Client do
  @moduledoc """
  The client schema.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Herenow.Clients.Storage.{EctoHashedPassword, Fields}

  schema "clients" do
    field :street_number, :string
    field :postal_code, :string
    field :city, :string
    field :email, :string
    field :is_company, :boolean
    field :legal_name, :string
    field :name, :string
    field :password, EctoHashedPassword
    field :segment, :string
    field :state, :string
    field :street_name, :string
    field :lat, :float
    field :lon, :float

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = client, attrs) do
    client
    |> cast(attrs, Fields.required_fields() ++ Fields.optional_fields())
    |> validate_required(Fields.required_fields())
    |> unique_constraint(:email)
  end
end
