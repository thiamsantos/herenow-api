defmodule PhxdemoWeb.AuthController do
  use PhxdemoWeb, :controller
  alias Phxdemo.Auth

  action_fallback PhxdemoWeb.FallbackController

  def create(conn, user_params) do
    if user_params["password"] == "toor" and user_params["user"] == "root" do
      render(conn, "auth.json", token: Auth.generate_token(%{user_id: 1}))
    else
      conn
      |> put_status(:unauthorized)
      |> render(PhxdemoWeb.ErrorView, "401.json", [])
    end
  end
end
