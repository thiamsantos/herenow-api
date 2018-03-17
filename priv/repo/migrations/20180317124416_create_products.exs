defmodule Herenow.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string
      add :category, :string
      add :code, :string
      add :price, :float
      add :description, :text
      add :client_id, references(:clients, on_delete: :nothing)

      timestamps()
    end

    create index(:products, [:client_id])
  end
end
