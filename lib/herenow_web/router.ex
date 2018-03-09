defmodule HerenowWeb.Router do
  use HerenowWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug PlugSecex, except: ["content-security-policy"]
    plug HerenowWeb.Plugs.AccessLogPlug
  end

  pipeline :auth do
    plug HerenowWeb.AuthPlug
  end

  scope "/v1", HerenowWeb do
    pipe_through :api

    post "/clients", ClientController, :create
    post "/verified-clients", ClientController, :verify
    post "/clients/request-activation", ClientController, :request_activation
    post "/clients/recover-password", ClientController, :recover_password
    post "/clients/password-recovery", ClientController, :request_password_recovery

    post "/auth/identity", AuthController, :create
  end

  scope "/v1", HerenowWeb do
    pipe_through [:api, :auth]

    put "/profile/password", ClientController, :update_password
  end

  if Mix.env() == :dev do
    forward "/sent_emails", Bamboo.EmailPreviewPlug
  end
end
