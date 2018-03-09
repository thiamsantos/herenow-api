defmodule Herenow.Clients.UpdatePassword.Params do
  @moduledoc """
  Schema of a client password update
  """
  use Ecto.Schema
  import Ecto.Changeset

  @fields [
    :current_password,
    :password,
    :client_id
  ]

  embedded_schema do
    field :client_id, :integer
    field :current_password, :string
    field :password, :string
  end

  @doc false
  def changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> validate_length(:password, min: 8)
  end
end
