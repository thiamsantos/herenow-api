defmodule HerenowWeb.Router do
  use HerenowWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug PlugSecex, except: ["content-security-policy"]
    plug HerenowWeb.Plugs.AccessLogPlug
  end

  scope "/v1", HerenowWeb do
    pipe_through :api

    resources "/clients", ClientController, only: [:create]
    post "/verified-clients", ClientController, :verify
    post "/clients/request-activation", ClientController, :request_activation
    post "/clients/recover-password", ClientController, :recover_password
    post "/clients/password-recovery", ClientController, :request_password_recovery

    post "/auth/identity", AuthController, :create
  end

  if Mix.env() == :dev do
    forward "/sent_emails", Bamboo.EmailPreviewPlug
  end
end
