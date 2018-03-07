defmodule Herenow.Clients.Storage.Queries do
  @moduledoc """
  Clients storage queries
  """
  import Ecto.Query, warn: false
  alias Herenow.Clients.Storage.{Client, VerifiedClient}

  def all, do: Client

  def one_by_email(email) do
    from c in Client, where: c.email == ^email
  end

  def password_by_email(email) do
    from c in Client,
      where: c.email == ^email,
      select: struct(c, [:id, :password])
  end

  def one_verified_client(id) do
    from c in VerifiedClient, where: c.client_id == ^id
  end
end
