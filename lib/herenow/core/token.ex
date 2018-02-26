defmodule Herenow.Core.Token do
  @moduledoc """
  Create and verify tokens
  """
  alias Joken

  def generate(payload, secret, expiration_time) do
    generate(payload, secret, expiration_time, Joken.current_time())
  end

  @spec generate(map, String.t(), integer, integer) :: String.t()
  def generate(payload, secret, expiration_time, current_time) do
    payload
    |> Joken.token()
    |> Joken.with_exp(current_time + expiration_time)
    |> Joken.with_iat(current_time)
    |> Joken.with_signer(Joken.hs256(secret))
    |> Joken.sign()
    |> Joken.get_compact()
    |> split_header()
  end

  def verify(encoded_token, secret) do
    verify(encoded_token, secret, Joken.current_time())
  end

  def verify(encoded_token, secret, current_time) do
    encoded_token
    |> concat_header()
    |> Joken.token()
    |> Joken.with_signer(Joken.hs256(secret))
    |> Joken.with_validation("exp", &(&1 > current_time), "Expired token")
    |> Joken.verify!()
  end

  defp split_header(encoded_token) do
    List.last(Regex.run(~r/.+?\.(.+)/, encoded_token))
  end

  defp concat_header(encoded_token) do
    get_header() <> "." <> encoded_token
  end

  defp get_header do
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9"
  end
end
