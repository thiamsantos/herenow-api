defmodule Herenow.Clients.Register do
  @moduledoc """
  Create a new client
  """
  @behaviour Herenow.Service

  alias Herenow.Core.{ErrorMessage, EctoUtils, ErrorHandler}
  alias Herenow.Clients.Register.Registration
  alias Herenow.Clients.Storage.{Client, Mutator}
  alias Herenow.Clients.Email.WelcomeEmail

  @captcha Application.get_env(:herenow, :captcha)

  @spec call(map) :: {:ok, %Client{}} | ErrorMessage.t()
  def call(params) do
    with {:ok, request} <- EctoUtils.validate(Registration, params),
         {:ok} <- @captcha.verify(request.captcha),
         {:ok, client} <- Mutator.create(params),
         _email <- WelcomeEmail.send(client) do
      {:ok, client}
    else
      {:error, reason} -> ErrorHandler.handle(reason)
    end
  end
end
