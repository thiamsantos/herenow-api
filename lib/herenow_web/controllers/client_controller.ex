defmodule HerenowWeb.ClientController do
  use HerenowWeb, :controller

  alias Herenow.Clients

  action_fallback HerenowWeb.FallbackController

  def create(conn, client_params) do
    with {:ok, client} <- Clients.register(client_params) do
      conn
      |> put_status(:created)
      |> render("show.json", client: client)
    end
  end
end
