defmodule Phxdemo.Auth do
  import Joken

  @secret Application.get_env(:phxdemo, :secret)
  @expiration_time 2 * 60 * 60

  def generate_token(payload) do
    payload
    |> token
    |> with_exp(current_time() + @expiration_time)
    |> with_iat
    |> with_signer(hs256(@secret))
    |> sign
    |> get_compact
  end

  def verify_token(encoded_token) do
    encoded_token
    |> token
    |> with_signer(hs256(@secret))
    |> verify!
  end
end
