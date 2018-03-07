defmodule Herenow.Clients.RecoverPassword.Token do
  @moduledoc """
  Generate and verify password recovery tokens
  """
  alias Herenow.Core.Token

  @secret Application.get_env(:herenow, :password_recovery_secret)
  @expiration_time Application.get_env(
                     :herenow,
                     :password_recovery_expiration_time
                   )

  def generate(payload) do
    Token.generate(payload, @secret, @expiration_time)
  end

  def verify(token) do
    Token.verify(token, @secret)
  end
end
