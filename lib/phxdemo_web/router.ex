defmodule PhxdemoWeb.Router do
  use PhxdemoWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug PlugSecex
  end

  scope "/", PhxdemoWeb do
    pipe_through :api

    resources "/users", UserController, except: [:new, :edit]
  end
end
