defmodule Herenow.Clients.Token do
  @moduledoc """
  Clients token generation and verification
  """

  alias Herenow.Core.Token

  @activation_secret Application.get_env(:herenow, :account_activation_secret)
  @activation_expiration_time Application.get_env(
                                :herenow,
                                :account_activation_expiration_time
                              )
  @login_secret Application.get_env(:herenow, :login_secret)
  @login_expiration_time Application.get_env(
                           :herenow,
                           :login_activation_expiration_time
                         )

  def generate_activation_token(payload) do
    Token.generate(payload, @activation_secret, @activation_expiration_time)
  end

  def verify_activation_token(token) do
    Token.verify(token, @activation_secret)
  end

  def generate_authentication_token(payload) do
    Token.generate(payload, @login_secret, @login_expiration_time)
  end

  def verify_authentication_token(token) do
    Token.verify(token, @login_secret)
  end
end
