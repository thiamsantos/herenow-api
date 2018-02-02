defmodule Herenow.Clients.Client do
  @moduledoc """
  The client schema.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Herenow.Clients.Client

  schema "clients" do
    field :address_number, :string
    field :cep, :string
    field :city, :string
    field :email, :string
    field :is_company, :boolean, default: false
    field :is_verified, :boolean, default: false
    field :legal_name, :string
    field :name, :string
    field :password, :string
    field :segment, :string
    field :state, :string
    field :street, :string

    timestamps()
  end

  @doc false
  def changeset(%Client{} = client, attrs) do
    client
    |> cast(attrs, [
      :email,
      :password,
      :is_verified,
      :name,
      :legal_name,
      :is_company,
      :segment,
      :cep,
      :street,
      :address_number,
      :city,
      :state
    ])
    |> validate_required([
      :email,
      :password,
      :is_verified,
      :name,
      :legal_name,
      :is_company,
      :segment,
      :cep,
      :street,
      :address_number,
      :city,
      :state
    ])
  end
end
