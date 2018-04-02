defmodule Herenow.Products do
  @moduledoc """
  The Products context.
  """
  alias Herenow.Products.{Show, Create, Update, List}

  def list(client_id), do: List.call(client_id)
  def show(params), do: Show.call(params)
  def create(params), do: Create.call(params)
  def update(params), do: Update.call(params)
end
