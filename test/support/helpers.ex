defmodule HerenowWeb.Helpers do
  alias Herenow.Clients.Authenticate.Token
  alias HerenowWeb.AuthPlug

  def get_client_id(conn) do
    {:ok, token} = AuthPlug.get_token(conn)
    {:ok, claims} = Token.verify(token)

    claims["client_id"]
  end
end
