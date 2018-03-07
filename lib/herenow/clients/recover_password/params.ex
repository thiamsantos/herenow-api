defmodule Herenow.Clients.RecoverPassword.Params do
@moduledoc """
  Schema of a client password recovery request
  """
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [
    :captcha,
    :token,
    :password
  ]

  embedded_schema do
    field :password, :string
    field :token, :string
    field :captcha, :string
  end

  @doc false
  def changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
