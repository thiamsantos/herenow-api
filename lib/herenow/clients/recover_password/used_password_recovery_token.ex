defmodule Herenow.Clients.RecoverPassword.UsedToken do
  @moduledoc """
  Used recover password schema.
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "used_password_recovery_token" do
    field :token, :string

    timestamps()
  end

  @doc false
  def changeset(used_token, attrs) do
    used_token
    |> cast(attrs, [:token])
    |> validate_required([:token])
    |> unique_constraint(:token)
  end
end
