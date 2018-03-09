defmodule Herenow.Repo.Migrations.CreateAccessLogs do
  use Ecto.Migration

  def change do
    create table(:access_logs) do
      add :method, :string
      add :remote_ip, :string
      add :request_path, :string
      add :user_agent, :string
      add :query_string, :string
      add :token_payload, :map

      timestamps()
    end

  end
end
