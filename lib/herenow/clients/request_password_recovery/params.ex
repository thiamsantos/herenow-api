defmodule Herenow.Clients.RequestPasswordRecovery.Params do
  @moduledoc """
  Schema of a request for a password recovery token
  """
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [
    :captcha,
    :email
  ]

  embedded_schema do
    field :email, :string
    field :captcha, :string
  end

  @doc false
  def changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> validate_length(:email, max: 254)
    |> validate_format(:email, ~r/@/)
  end
end
