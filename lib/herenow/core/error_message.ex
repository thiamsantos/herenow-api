defmodule Herenow.Core.ErrorMessage do
  @type t :: {:error, {atom, map}}

  @spec create(atom, String.t) :: __MODULE__.t
  def create(type, message) do
    {:error, {type, %{"message" => message}}}
  end
end
