defmodule Herenow.Core.Email.Body do
  @type t :: %__MODULE__{html: String.t, text: String.t}

  @enforce_keys [:html, :text]
  defstruct [:html, :text]
end
