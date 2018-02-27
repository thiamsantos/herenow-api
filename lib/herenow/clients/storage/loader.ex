defmodule Herenow.Clients.Storage.Loader do
  @moduledoc """
  Read operation on clients storage
  """
  alias Herenow.Repo
  alias Herenow.Clients.Storage.{Client, Queries}

  @doc """
  Returns the list of clients.

  ## Examples

      iex> all()
      [%Client{}, ...]

  """
  def all, do: Repo.all(Queries.all())

  def get!(id), do: Repo.get!(Client, id)

  def get_one_by_email(email), do: Repo.one(Queries.one_by_email(email))
end
