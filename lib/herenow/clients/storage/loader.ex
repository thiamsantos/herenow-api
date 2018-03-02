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

  def get_password_by_email(email) do
    client = Repo.one(Queries.password_by_email(email))

    if is_nil(client) do
      {:error, :email_not_found}
    else
      {:ok, client}
    end
  end

  def is_verified?(id) do
    client = Repo.one(Queries.one_verified_client(id))

    if is_nil(client) do
      {:error, :account_not_verified}
    else
      {:ok, client}
    end
  end
end
