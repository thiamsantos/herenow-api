defmodule Herenow.Clients.Storage.Loader do
  @moduledoc """
  Read operation on clients storage
  """
  alias Herenow.Repo
  alias Herenow.Clients.Storage.{Client, Queries}

  def all,
    do: Repo.all(Queries.all)

  def get!(id), do: Repo.get!(Client, id)

  @spec is_email_registered?(String.t) :: boolean()
  def is_email_registered?(email) do
    case Repo.one(Queries.get_id_by_email(email)) do
      nil -> false
      _client -> true
    end
  end
end
