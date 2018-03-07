defmodule Herenow.Clients.Authenticate.Token do
  @moduledoc """
  Clients token generation and verification
  """
  alias Herenow.Core.Token

  @secret Application.get_env(:herenow, :login_secret)
  @expiration_time Application.get_env(
                     :herenow,
                     :login_activation_expiration_time
                   )

  def generate(payload) do
    Token.generate(payload, @secret, @expiration_time)
  end

  def verify(token) do
    Token.verify(token, @secret)
  end
end
