defmodule Herenow.Clients.RecoverPassword.Queries do
  @moduledoc """
  Used token table queries
  """
  import Ecto.Query, warn: false
  alias Herenow.Clients.RecoverPassword.UsedToken

  def one_by_token(token) do
    from u in UsedToken, where: u.token == ^token
  end
end
