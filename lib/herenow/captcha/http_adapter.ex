defmodule Herenow.Captcha.HTTPAdapter do
  @behaviour Herenow.Captcha
  @moduledoc """
  Verify Captcha responses by making a http call.
  """
  def verify(response, options \\ []) do
    case Recaptcha.verify(response, options) do
      {:ok, _response} -> {:ok}
      {:error, errors} -> {:error, errors}
    end
  end
end
