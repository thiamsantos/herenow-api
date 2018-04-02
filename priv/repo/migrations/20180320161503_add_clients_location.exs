defmodule Herenow.Repo.Migrations.AddClientsLocation do
  use Ecto.Migration

  def change do
    alter table(:clients) do
      add :lat, :float
      add :lon, :float
    end
  end
end
