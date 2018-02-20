defmodule Herenow.Core.Email.Body do
  @moduledoc """
  An email body
  """
  @type t :: %__MODULE__{html: String.t(), text: String.t()}

  @enforce_keys [:html, :text]
  defstruct [:html, :text]
end
