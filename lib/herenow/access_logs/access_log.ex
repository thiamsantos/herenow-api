defmodule Herenow.AccessLogs.AccessLog do
  @moduledoc """
  Access log schema
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Herenow.AccessLogs.EctoIP

  @optional_fields [
    :user_agent,
    :query_string,
    :token_payload
  ]

  @required_fields [
    :method,
    :remote_ip,
    :request_path
  ]

  schema "access_logs" do
    field :method, :string
    field :query_string, :string
    field :remote_ip, EctoIP
    field :request_path, :string
    field :token_payload, :map
    field :user_agent, :string

    timestamps()
  end

  @doc false
  def changeset(access_log, attrs) do
    access_log
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
