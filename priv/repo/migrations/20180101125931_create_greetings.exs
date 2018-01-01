defmodule Phxdemo.Repo.Migrations.CreateGreetings do
  use Ecto.Migration

  def change do
    create table(:greetings) do
      add :content, :string, null: false
      timestamps
    end
  end
end
