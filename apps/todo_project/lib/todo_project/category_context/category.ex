defmodule TodoProject.CategoryContext.Category do
  use Ecto.Schema
  import Ecto.Changeset
  import TodoProject, only: [get_string_character_limit: 0]
  alias TodoProject.TodoContext.Todo

  schema "categories" do
    field :category, :string
    many_to_many :todos, Todo, join_through: "todos_categories", on_replace: :delete
    # timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:category])
    |> validate_required([:category])
    |> validate_length(:category, count: :codepoints, max: get_string_character_limit())
    |> unique_constraint(:category,
      name: :unique_categories_index,
      message: "A category with the same name already exists"
    )

    # |> cast_assoc(:todos)
  end
end
