defmodule Phxdemo.Auth do
  @moduledoc """
  Authentication context
  """
  import Joken

  @secret Application.get_env(:phxdemo, :secret)
  @expiration_time 2 * 60 * 60

  @spec generate_token(map) :: binary
  def generate_token(payload) do
    payload
    |> token
    |> with_exp(current_time() + @expiration_time)
    |> with_iat
    |> with_signer(hs256(@secret))
    |> sign
    |> get_compact
  end

  def verify_token({:error, reason}) do
    {:error, reason}
  end

  def verify_token({:ok, encoded_token}) do
    verify_token(encoded_token)
  end

  def verify_token(encoded_token) do
    encoded_token
    |> token
    |> with_signer(hs256(@secret))
    |> with_validation("exp", &(&1 > current_time()), "Expired token")
    |> verify!
  end
end
