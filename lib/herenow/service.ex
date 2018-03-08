defmodule Herenow.Service do
  @moduledoc """
  Service behaviour
  """

  alias Herenow.Core.ErrorMessage
  @callback run(map) :: {:ok, struct | map | String.t()} | ErrorMessage.t()

  defmacro __using__(_) do
    quote do
      @behaviour Herenow.Service
      import Herenow.Repo, only: [transaction: 1, rollback: 1]

      def call(params) do
        transaction(fn ->
          with {:ok, response} <- run(params) do
            response
          else
            {:error, reason} -> rollback(reason)
          end
        end)
      end
    end
  end
end
