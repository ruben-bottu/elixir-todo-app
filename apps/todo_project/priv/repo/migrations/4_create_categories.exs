defmodule TodoProject.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :category, :string, null: false

      # timestamps()
    end

    create unique_index(:categories, [:category], name: :unique_categories_index)
  end
end
