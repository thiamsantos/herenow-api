defmodule HerenowWeb.Router do
  use HerenowWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug PlugSecex, except: ["content-security-policy"]
  end

  scope "/", HerenowWeb do
    pipe_through :api
  end
end
