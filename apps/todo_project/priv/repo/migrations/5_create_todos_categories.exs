defmodule TodoProject.Repo.Migrations.CreateTodosCategories do
  use Ecto.Migration

  def change do
    create table(:todos_categories) do
      add :todo_id, references(:todos, on_delete: :delete_all)
      add :category_id, references(:categories, on_delete: :delete_all)
    end

    create unique_index(:todos_categories, [:todo_id, :category_id])
    create unique_index(:todos_categories, [:category_id, :todo_id])
  end
end
