defmodule HerenowWeb.VerifiedClientController do
  use HerenowWeb, :controller

  alias Herenow.Clients
  alias HerenowWeb.ClientView

  action_fallback(HerenowWeb.FallbackController)

  def create(conn, params) do
    with {:ok, client} <- Clients.activate(params) do
      conn
      |> put_status(:ok)
      |> render(ClientView, "show.json", client: client)
    end
  end
end
