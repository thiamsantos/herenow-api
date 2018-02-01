defmodule HereNowWeb.AuthView do
  use HereNowWeb, :view

  def render("auth.json", %{token: token}) do
    %{token: token}
  end
end
