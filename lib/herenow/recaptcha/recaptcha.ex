defmodule Herenow.Recaptcha do
  @moduledoc """
  Verify recaptcha responses.
  """
  @spec verify(String.t, Keyword.t) :: {:ok} | {:error, [atom]}
  def verify(response, options \\ []) do
    case Recaptcha.verify(response, options) do
      {:ok, _response} -> {:ok}
      {:error, errors} -> {:error, errors}
    end
  end
end
