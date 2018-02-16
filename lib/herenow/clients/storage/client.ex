defmodule Herenow.Clients.Storage.Client do
  @moduledoc """
  The client schema.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Herenow.Clients.Storage.{Client, EctoHashedPassword}

  @accepted_fields [
    :email,
    :password,
    :name,
    :legal_name,
    :is_company,
    :segment,
    :cep,
    :street,
    :address_number,
    :city,
    :state
  ]

  @required_fields [
    :email,
    :password,
    :name,
    :segment,
    :cep,
    :street,
    :address_number,
    :city,
    :state
  ]

  schema "clients" do
    field :address_number, :string
    field :cep, :string
    field :city, :string
    field :email, :string
    field :is_company, :boolean
    field :legal_name, :string
    field :name, :string
    field :password, EctoHashedPassword
    field :segment, :string
    field :state, :string
    field :street, :string

    timestamps()
  end

  @doc false
  def changeset(%Client{} = client, attrs) do
    client
    |> cast(attrs, @accepted_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:email)
    |> validate_length(:email, max: 254)
    |> validate_length(:cep, is: 8)
  end
end
