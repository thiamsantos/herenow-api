defmodule Herenow.Clients.RecoverPassword.Mutator do
  @moduledoc """
  Mutation operations on used token table
  """
  alias Herenow.Repo
  alias Herenow.Clients.RecoverPassword.UsedToken

  def store_token(token) do
    %UsedToken{}
    |> UsedToken.changeset(%{token: token})
    |> Repo.insert()
  end
end
