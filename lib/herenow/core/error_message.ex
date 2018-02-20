defmodule Herenow.Core.ErrorMessage do
  @moduledoc """
  Error message builder
  """
  @type t :: {:error, {atom, String.t() | map | {atom, String.t()}}}

  @spec create(atom, String.t()) :: __MODULE__.t()
  def create(type, message) do
    {:error, {type, message}}
  end

  @spec validation(String.t()) :: __MODULE__.t()
  def validation(error) when is_binary(error), do: create(:validation, error)

  @spec validation(List.t()) :: __MODULE__.t()
  def validation(error) when is_list(error), do: create(:validation, error)

  @spec validation(String.t(), atom, String.t()) :: __MODULE__.t()
  def validation(field, type, message) do
    create(:validation, %{"field" => field, "type" => type, "message" => message})
  end
end
