defmodule Herenow.Clients.Validation.Activation do
  @moduledoc """
  Schema of a client activation request
  """
  use Ecto.Schema
  import Ecto.Changeset

  @fields [
    :token,
    :captcha
  ]

  embedded_schema do
    field :token, :string
    field :captcha, :string
  end

  @doc false
  def changeset(%__MODULE__{} = activation, attrs) do
    activation
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end
