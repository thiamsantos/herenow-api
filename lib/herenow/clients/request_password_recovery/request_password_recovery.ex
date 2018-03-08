defmodule Herenow.Clients.RequestPasswordRecovery do
  @moduledoc """
  Request a password recovery token and send via email
  """
  use Herenow.Service

  alias Herenow.Core.{EctoUtils, ErrorHandler}
  alias Herenow.Clients.RequestPasswordRecovery.Params

  @captcha Application.get_env(:herenow, :captcha)

  def run(params) do
    with {:ok, request} <- EctoUtils.validate(Params, params),
         {:ok} <- @captcha.verify(request.captcha) do
      {:ok, request}
    else
      {:error, reason} -> ErrorHandler.handle(reason)
    end
  end
end
