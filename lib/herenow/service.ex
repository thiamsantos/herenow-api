defmodule Herenow.Service do
  @moduledoc """
  Service behaviour
  """

  alias Herenow.Core.ErrorMessage
  @callback call(map) :: {:ok, struct | map | String.t()} | ErrorMessage.t()
end
