defmodule Herenow.Clients.RecoverPassword do
  @moduledoc """
  Recovers the password of a client
  """
  @behaviour Herenow.Service
  use Herenow.Service, captcha: true

  alias Herenow.Core.{EctoUtils, ErrorHandler}
  alias Herenow.Clients.RecoverPassword.{Params, Token}

  @captcha Application.get_env(:herenow, :captcha)

  def run(params) do
    with {:ok, request} <- EctoUtils.validate(Params, params),
         {:ok} <- @captcha.verify(request.captcha),
         {:ok, payload} <- Token.verify(request.token) do
      {:ok, "nothing"}
    else
      {:error, reason} -> ErrorHandler.handle(reason)
    end
  end
end
