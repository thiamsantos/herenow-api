defmodule HerenowWeb.AuthController do
  use HerenowWeb, :controller

  alias Herenow.Clients

  action_fallback(HerenowWeb.FallbackController)

  def create(conn, params) do
    with {:ok, token} <- Clients.authenticate(params) do
      conn
      |> put_status(:created)
      |> render("show.json", token: token)
    end
  end
end
