defmodule Herenow.Repo.Migrations.CreateUsedPasswordRecoveryToken do
  use Ecto.Migration

  def change do
    create table(:used_password_recovery_token) do
      add :token, :string

      timestamps()
    end

    create unique_index(:used_password_recovery_token, [:token])
  end
end
