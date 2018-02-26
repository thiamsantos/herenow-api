defmodule Herenow.Repo.Migrations.CreateVerifiedClients do
  use Ecto.Migration

  def change do
    create table(:verified_clients) do
      add :client_id, references(:clients, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:verified_clients, [:client_id])
  end
end
