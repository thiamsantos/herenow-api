defmodule Herenow.Clients.RequestActivation do
  @moduledoc """
  Request the activation of a client
  """
  @behaviour Herenow.Service

  alias Herenow.Core.{ErrorMessage, ErrorHandler, EctoUtils}
  alias Herenow.Clients.RequestActivation.ActivationRequest
  alias Herenow.Clients.Email.RequestActivationEmail

  @captcha Application.get_env(:herenow, :captcha)

  @spec call(map) :: {:ok, map} | ErrorMessage.t()
  def call(params) do
    with {:ok, request} <- EctoUtils.validate(ActivationRequest, params),
         {:ok} <- @captcha.verify(request.captcha),
         _email <- RequestActivationEmail.send(request.email) do
      {:ok, %{message: "Email successfully sended!"}}
    else
      {:error, reason} -> ErrorHandler.handle(reason)
    end
  end
end
