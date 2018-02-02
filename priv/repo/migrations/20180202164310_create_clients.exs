defmodule Herenow.Repo.Migrations.CreateClients do
  use Ecto.Migration

  def change do
    create table(:clients) do
      add :email, :string
      add :password, :string
      add :is_verified, :boolean, default: false, null: false
      add :name, :string
      add :legal_name, :string
      add :is_company, :string
      add :segment, :string
      add :cep, :string
      add :street, :string
      add :address_number, :string
      add :city, :string
      add :state, :string

      timestamps()
    end

  end
end
