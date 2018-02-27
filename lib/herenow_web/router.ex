defmodule HerenowWeb.Router do
  use HerenowWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug PlugSecex, except: ["content-security-policy"]
  end

  scope "/", HerenowWeb do
    pipe_through :api

    resources "/clients", ClientController, only: [:create]
    post "/verified-clients", ClientController, :verify
    post "/clients/request-activation", ClientController, :request_activation
  end

  if Mix.env() == :dev do
    # If using Phoenix
    forward "/sent_emails", Bamboo.EmailPreviewPlug
  end
end
