defmodule TodoProject.StatusContext.Status do
  use Ecto.Schema
  import Ecto.Changeset
  import TodoProject, only: [get_string_character_limit: 0]
  alias TodoProject.TodoContext.Todo

  schema "statuses" do
    field :status, :string
    has_many :todos, Todo

    # timestamps()
  end

  @doc false
  def changeset(status, attrs) do
    status
    |> cast(attrs, [:status])
    |> validate_required([:status])
    |> validate_length(:status, count: :codepoints, max: get_string_character_limit())
    |> unique_constraint(:status,
      name: :unique_statuses_index,
      message: "A status with the same name already exists"
    )
  end
end
