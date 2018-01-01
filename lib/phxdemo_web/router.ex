defmodule PhxdemoWeb.Router do
  use PhxdemoWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PhxdemoWeb do
    pipe_through :api

    resources "/greetings", GreetingController, except: [:new, :edit]
  end
end
