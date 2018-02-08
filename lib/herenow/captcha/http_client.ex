defmodule Herenow.Captcha.HTTPClient do
  @behaviour Herenow.Captcha
  @moduledoc """
  Verify Captcha responses by making a http call.
  """
  def verify(response, options \\ []) do
    case Captcha.verify(response, options) do
      {:ok, _response} -> {:ok}
      {:error, errors} -> {:error, errors}
    end
  end
end
