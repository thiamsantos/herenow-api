defmodule HerenowWeb.AuthView do
  use HerenowWeb, :view

  def render("show.json", %{token: token}) do
    %{
      token: token
    }
  end
end
