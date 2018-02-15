defmodule Herenow.Captcha.TestAdapter do
  @behaviour Herenow.Captcha
  @moduledoc """
  Mock Captcha responses.
  """

  alias Herenow.Core.ErrorMessage

  def verify(response, _options \\ []) do
    case response do
      "valid" -> {:ok}
      _ -> ErrorMessage.validation("Invalid captcha")
    end
  end
end
