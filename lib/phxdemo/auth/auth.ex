defmodule HereNow.Auth do
  @moduledoc """
  Authentication context
  """
  import Joken

  @secret Application.get_env(:herenow, :secret)
  @expiration_time 2 * 60 * 60

  @spec generate_token(map) :: binary
  def generate_token(payload, iat \\ current_time()) do
    payload
    |> token
    |> with_exp(iat + @expiration_time)
    |> with_iat(iat)
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

  def verify_token(encoded_token, now \\ current_time()) do
    encoded_token
    |> token
    |> with_signer(hs256(@secret))
    |> with_validation("exp", &(&1 > now), "Expired token")
    |> verify!
  end
end
