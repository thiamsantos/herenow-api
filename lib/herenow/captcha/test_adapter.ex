defmodule Herenow.Captcha.TestAdapter do
  @behaviour Herenow.Captcha
  @moduledoc """
  Mock Captcha responses.
  """
  def verify(_response, _options \\ []) do
    {:ok}
  end
end
