defmodule PhxdemoWeb.Router do
  use PhxdemoWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug PlugSecex, except: ["content-security-policy"]
  end

  pipeline :authentication do
    plug PhxdemoWeb.AuthPlug
  end

  scope "/", PhxdemoWeb do
    pipe_through [:api, :authentication]

    resources "/users", UserController, except: [:new, :edit]
  end

  scope "/", PhxdemoWeb do
    pipe_through :api

    resources "/auth", AuthController, only: [:create]
  end
end
