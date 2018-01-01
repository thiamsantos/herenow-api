defmodule PhxdemoWeb.GreetingView do
  use PhxdemoWeb, :view

  def render("index.json", %{greeting: greeting}) do
    %{greeting: greeting}
  end
end
