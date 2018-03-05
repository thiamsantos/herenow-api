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
    email
    |> Queries.password_by_email()
    |> Repo.one()
    |> handle_password_query()
  end

  def handle_password_query(client) when is_nil(client) do
    {:error, :email_not_found}
  end

  def handle_password_query(client) do
    {:ok, client}
  end

  def is_verified?(id) do
    id
    |> Queries.one_verified_client()
    |> Repo.one()
    |> handle_verified_query()
  end

  defp handle_verified_query(client) when is_nil(client) do
    {:error, :account_not_verified}
  end

  defp handle_verified_query(client) do
    {:ok, client}
  end
end
