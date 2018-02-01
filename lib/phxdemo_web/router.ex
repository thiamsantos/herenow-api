defmodule HereNowWeb.Router do
  use HereNowWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug PlugSecex, except: ["content-security-policy"]
  end

  pipeline :authentication do
    plug HereNowWeb.AuthPlug
  end

  scope "/", HereNowWeb do
    pipe_through [:api, :authentication]

    resources "/users", UserController, except: [:new, :edit]
  end

  scope "/", HereNowWeb do
    pipe_through :api

    resources "/auth", AuthController, only: [:create]
  end
end
