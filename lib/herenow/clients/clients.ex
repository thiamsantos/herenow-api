defmodule Herenow.Clients do
  @moduledoc """
  The Clients context.
  """
  alias Herenow.Clients.{Register, Activate, RequestActivation, Authenticate}

  def register(params), do: Register.call(params)
  def activate(params), do: Activate.call(params)
  def request_activation(params), do: RequestActivation.call(params)
  def authenticate(params), do: Authenticate.call(params)
end
