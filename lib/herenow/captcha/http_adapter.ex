defmodule Herenow.Captcha.HTTPAdapter do
  @behaviour Herenow.Captcha
  @moduledoc """
  Verify Captcha responses by making a http call.
  """

  alias Herenow.Core.ErrorMessage

  def verify(response, options \\ []) do
    case Recaptcha.verify(response, options) do
      {:ok, _response} -> {:ok}
      {:error, _errors} -> ErrorMessage.validation(nil, :invalid_captcha, "Invalid captcha")
    end
  end
end
