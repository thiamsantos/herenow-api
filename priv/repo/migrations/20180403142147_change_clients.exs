defmodule Herenow.Repo.Migrations.ChangeClients do
  use Ecto.Migration

  def change do
    alter table(:clients) do
      add :latitude, :float
      add :longitude, :float
      remove :street_number
    end

    rename table(:clients), :street_name, to: :street_address
  end
end
