defmodule Herenow.Clients.Registration do
  @moduledoc """
  Schema of a client registration request
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Herenow.Clients.Storage.Fields

  @required_fields [
    :captcha
  ]

  embedded_schema do
    field :email, :string
    field :password, :string
    field :name, :string
    field :legal_name, :string
    field :is_company, :boolean
    field :segment, :string
    field :postal_code, :string
    field :street_name, :string
    field :street_number, :string
    field :city, :string
    field :state, :string
    field :captcha, :string
  end

  @doc false
  def changeset(%__MODULE__{} = registration, attrs) do
    required_fields = Fields.required_fields() ++ @required_fields

    registration
    |> cast(attrs, required_fields ++ Fields.optional_fields())
    |> validate_required(required_fields)
    |> validate_length(:email, max: 254)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 8)
    |> validate_length(:postal_code, is: 8)
  end
end
