defmodule PhxdemoWeb.Router do
  use PhxdemoWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug PlugSecex, except: ["content-security-policy"]
  end

  scope "/", PhxdemoWeb do
    pipe_through :api

    resources "/users", UserController, except: [:new, :edit]
  end
end
