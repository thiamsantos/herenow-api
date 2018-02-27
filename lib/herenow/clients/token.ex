defmodule Herenow.Clients.Token do
  @moduledoc """
  Clients token generation and verification
  """

  alias Herenow.Core.Token

  @secret Application.get_env(:herenow, :account_activation_secret)
  @expiration_time Application.get_env(
                     :herenow,
                     :account_activation_expiration_time
                   )

  def generate_activation_token(payload) do
    Token.generate(payload, @secret, @expiration_time)
  end

  def verify_activation_token(token) do
    Token.verify(token, @secret)
  end
end
