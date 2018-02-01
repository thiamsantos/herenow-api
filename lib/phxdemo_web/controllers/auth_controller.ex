defmodule HereNowWeb.AuthController do
  use HereNowWeb, :controller
  alias HereNow.Auth

  action_fallback HereNowWeb.FallbackController

  def create(conn, user_params) do
    if user_params["password"] == "toor" and user_params["user"] == "root" do
      render(conn, "auth.json", token: Auth.generate_token(%{user_id: 1}))
    else
      conn
      |> put_status(:unauthorized)
      |> render(HereNowWeb.ErrorView, "401.json", %{reason: "Invalid credentials"})
    end
  end
end
