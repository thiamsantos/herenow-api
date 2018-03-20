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
    |> handle_password_by_email_query()
  end

  defp handle_password_by_email_query(client) when is_nil(client) do
    {:error, :email_not_found}
  end

  defp handle_password_by_email_query(client) do
    {:ok, client}
  end

  @spec get_password(integer) :: {:ok, String.t()} | {:error, :client_not_found}
  def get_password(id) do
    id
    |> Queries.password_by_id()
    |> Repo.one()
    |> handle_password_query()
  end

  defp handle_password_query(password) when is_nil(password) do
    {:error, :client_not_found}
  end

  defp handle_password_query(password) do
    {:ok, password}
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

  def get_location(id) do
    id
    |> Queries.location_by_id()
    |> Repo.one()
    |> handle_location()
  end

  defp handle_location(nil) do
    {:error, :client_not_found}
  end

  defp handle_location(client) do
    {:ok, client}
  end
end
