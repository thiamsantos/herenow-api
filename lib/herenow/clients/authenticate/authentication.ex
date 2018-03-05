defmodule Herenow.Clients.Authenticate.Authentication do
  @moduledoc """
  Schema of a client authentication
  """
  use Ecto.Schema
  import Ecto.Changeset

  @fields [
    :email,
    :password,
    :captcha
  ]

  embedded_schema do
    field :email, :string
    field :password, :string
    field :captcha, :string
  end

  @doc false
  def changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> validate_length(:email, max: 254)
    |> validate_format(:email, ~r/@/)
  end
end
