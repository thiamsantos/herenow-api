defmodule Herenow.Captcha do
  @moduledoc """
  Verify Captcha responses.
  """

  alias Herenow.Core.ErrorMessage

  @callback verify(String.t(), Keyword.t()) :: {:ok} | ErrorMessage.t()
end
