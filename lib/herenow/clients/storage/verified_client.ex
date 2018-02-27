defmodule Herenow.Clients.Storage.VerifiedClient do
  @moduledoc """
  The verified client schema.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "verified_clients" do
    field :client_id, :id

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = verified_client, attrs) do
    verified_client
    |> cast(attrs, [:client_id])
    |> validate_required([:client_id])
    |> foreign_key_constraint(:client_id)
    |> unique_constraint(:client_id)
  end
end
