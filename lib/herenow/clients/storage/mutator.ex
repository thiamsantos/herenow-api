defmodule Herenow.Clients.Storage.Mutator do
  @moduledoc """
  Mutation operations on clients storage
  """
  alias Herenow.Repo
  alias Herenow.Clients.Storage.Client

  @doc """
  Creates a client.

  ## Examples

      iex> create(%{field: value})
      {:ok, %Client{}}

      iex> create(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create(attrs \\ %{}) do
    %Client{}
    |> Client.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a client.

  ## Examples

      iex> update(client, %{field: new_value})
      {:ok, %Client{}}

      iex> update(client, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update(%Client{} = client, attrs) do
    client
    |> Client.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Client.

  ## Examples

      iex> delete_client(client)
      {:ok, %Client{}}

      iex> delete_client(client)
      {:error, %Ecto.Changeset{}}

  """
  def delete_client(%Client{} = client) do
    Repo.delete(client)
  end
end
