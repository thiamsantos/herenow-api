defmodule Herenow.Clients.Activate.Activation do
  @moduledoc """
  Schema of a client activation
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
  def changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end
