defmodule Herenow.Clients.RecoverPassword.Loader do
  @moduledoc """
  Read operation on used token table
  """
  alias Herenow.Repo
  alias Herenow.Clients.RecoverPassword.{UsedToken, Queries}

  def is_token_used?(token) do
    token
    |> Queries.one_by_token()
    |> Repo.one()
    |> handle_token_query()
  end

  def handle_token_query(nil), do: {:ok, false}

  def handle_token_query(%UsedToken{} = _used_token) do
    {:error, :used_token}
  end
end
