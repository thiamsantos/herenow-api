defmodule Herenow.Clients.Activate.Token do
  @moduledoc """
  Generate and verify activation tokens
  """
  alias Herenow.Core.Token

  @secret Application.get_env(:herenow, :account_activation_secret)
  @expiration_time Application.get_env(
                     :herenow,
                     :account_activation_expiration_time
                   )

  def generate(payload) do
    Token.generate(payload, @secret, @expiration_time)
  end

  def verify(token) do
    Token.verify(token, @secret)
  end
end
