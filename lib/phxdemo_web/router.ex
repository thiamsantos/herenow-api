defmodule PhxdemoWeb.Router do
  use PhxdemoWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PhxdemoWeb do
    pipe_through :api
  end
end
