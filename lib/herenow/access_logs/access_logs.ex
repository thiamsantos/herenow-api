defmodule Herenow.AccessLogs do
  @moduledoc """
  The AccessLogs context.
  """

  import Ecto.Query, warn: false
  alias Herenow.Repo

  alias Herenow.AccessLogs.AccessLog

  @doc """
  Creates a access_log.

  ## Examples

      iex> create_access_log(%{field: value})
      {:ok, %AccessLog{}}

      iex> create_access_log(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def log(attrs \\ %{}) do
    %AccessLog{}
    |> AccessLog.changeset(attrs)
    |> Repo.insert()
  end
end
