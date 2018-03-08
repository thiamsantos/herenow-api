defmodule Herenow.Clients.Register do
  @moduledoc """
  Create a new client
  """
  use Herenow.Service

  alias Herenow.Core.{EctoUtils, ErrorHandler}
  alias Herenow.Clients.Register.Params
  alias Herenow.Clients.Storage.Mutator
  alias Herenow.Clients.Email.WelcomeEmail

  @captcha Application.get_env(:herenow, :captcha)

  def run(params) do
    with {:ok, request} <- EctoUtils.validate(Params, params),
         {:ok} <- @captcha.verify(request.captcha),
         {:ok, client} <- Mutator.create(params),
         _email <- WelcomeEmail.send(client) do
      {:ok, client}
    else
      {:error, reason} -> ErrorHandler.handle(reason)
    end
  end
end
