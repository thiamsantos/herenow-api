defmodule Herenow.Core.ErrorMessage do
  @moduledoc """
  Error message builder
  """
  @type t :: {:error, {atom, String.t}}

  @spec create(atom, String.t) :: __MODULE__.t
  def create(type, message) do
    {:error, {type, message}}
  end

  @spec validation(String.t) :: __MODULE__.t
  def validation(message) do
    create(:unprocessable_entity, message)
  end
end
