defmodule Herenow.Core.Token do
  @moduledoc """
  Create and verify tokens
  """
  alias Joken

  @secret Application.get_env(:herenow, :secret)
  @expiration_time 2 * 60 * 60

  @spec generate(map, integer) :: String.t()
  def generate(payload, iat \\ Joken.current_time()) do
    payload
    |> Joken.token()
    |> Joken.with_exp(iat + @expiration_time)
    |> Joken.with_iat(iat)
    |> Joken.with_signer(Joken.hs256(@secret))
    |> Joken.sign()
    |> Joken.get_compact()
    |> split_header()
  end

  def verify({:error, reason}) do
    {:error, reason}
  end

  def verify({:ok, encoded_token}) do
    verify(encoded_token)
  end

  def verify(encoded_token, now \\ Joken.current_time()) do
    encoded_token
    |> concat_header()
    |> Joken.token()
    |> Joken.with_signer(Joken.hs256(@secret))
    |> Joken.with_validation("exp", &(&1 > now), "Expired token")
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
