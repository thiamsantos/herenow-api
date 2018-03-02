defmodule Herenow.Clients.Validation.ActivationRequest do
  @moduledoc """
  Schema of a request for a client activation
  """
  use Ecto.Schema
  import Ecto.Changeset

  @fields [
    :email,
    :captcha
  ]

  embedded_schema do
    field :email, :string
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
