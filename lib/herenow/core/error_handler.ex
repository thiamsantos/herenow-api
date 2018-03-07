defmodule Herenow.Core.ErrorHandler do
  @moduledoc """
  Handle errors
  """
  alias Herenow.Core.ErrorMessage
  alias Herenow.Core.EctoUtils
  alias Ecto.Changeset

  def handle(reason) when is_tuple(reason), do: {:error, reason}

  def handle(reason) when is_binary(reason) do
    type =
      reason
      |> String.downcase()
      |> String.replace(" ", "_")
      |> String.to_atom()

    ErrorMessage.validation(nil, type, reason)
  end

  def handle(%Changeset{} = changeset) do
    changeset
    |> EctoUtils.traverse_errors()
    |> ErrorMessage.validation()
  end
end
