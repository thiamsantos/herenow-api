defmodule HereNow.Users.User do
  @moduledoc """
  User schema
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias HereNow.Users.User

  @required_fields [:name, :age]

  schema "users" do
    field :age, :integer
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :age])
    |> validate_required(@required_fields)
  end
end
