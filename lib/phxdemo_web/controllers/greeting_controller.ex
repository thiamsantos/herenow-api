defmodule PhxdemoWeb.GreetingController do
  use PhxdemoWeb, :controller

  def index(conn, _params) do
    render conn, :index,  %{greeting: "Hello World"}
  end
end
