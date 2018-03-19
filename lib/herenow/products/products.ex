defmodule Herenow.Products do
  @moduledoc """
  The Products context.
  """
  alias Herenow.Products.{Show, Create, Update, List}

  def list, do: List.call(%{})
  def show(params), do: Show.call(params)
  def create(params), do: Create.call(params)
  def update(params), do: Update.call(params)
end
