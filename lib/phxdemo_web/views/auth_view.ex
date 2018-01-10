defmodule PhxdemoWeb.AuthView do
  use PhxdemoWeb, :view

  def render("auth.json", %{token: token}) do
    %{token: token}
  end
end
