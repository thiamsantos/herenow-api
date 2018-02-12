defmodule Herenow.Clients.Storage.Queries do
  @moduledoc """
  Clients storage queries
  """
  import Ecto.Query, warn: false
  alias Herenow.Clients.Storage.Client

  def all, do: Client

  def get_id_by_email(email) do
    from c in Client, where: c.email == ^email, select: c.id
  end
end
