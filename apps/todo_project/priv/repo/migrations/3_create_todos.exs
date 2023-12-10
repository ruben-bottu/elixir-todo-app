defmodule TodoProject.Repo.Migrations.CreateTodos do
  use Ecto.Migration

  def change do
    create table(:todos) do
      add :name, :string, null: false
      add :deadline, :date, null: false
      add :description, :string
      add :status_id, references(:statuses)
      add :user_id, references(:users)

      # timestamps()
    end

    create unique_index(:todos, [:name], name: :unique_todos_index)
  end
end
