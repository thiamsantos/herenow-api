defmodule Herenow.Captcha do
  @moduledoc """
  Verify Captcha responses.
  """
  @callback verify(String.t, Keyword.t) :: {:ok} | {:error, [atom]}
end
