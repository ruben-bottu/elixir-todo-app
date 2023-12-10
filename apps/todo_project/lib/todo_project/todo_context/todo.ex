defmodule TodoProject.TodoContext.Todo do
  use Ecto.Schema
  import Ecto.Changeset
  import TodoProject, only: [get_string_character_limit: 0]
  alias TodoProject.TodoContext.Todo
  alias TodoProject.StatusContext.Status
  alias TodoProject.UserContext.User
  alias TodoProject.CategoryContext.Category

  @year_range_offset 20

  schema "todos" do
    field :name, :string
    field :deadline, :date
    field :description, :string
    belongs_to :status, Status, on_replace: :nilify
    belongs_to :user, User, on_replace: :nilify
    many_to_many :categories, Category, join_through: "todos_categories", on_replace: :delete

    # timestamps()
  end

  def get_valid_year_range() do
    current_year = DateTime.utc_now().year
    current_year..(current_year + @year_range_offset)
  end

  def year_inclusion_validator(_field, %Date{} = date, %Range{} = year_range) do
    # year_range = get_valid_year_range()
    if date.year in year_range do
      []
    else
      [deadline: "Year must be between #{year_range.first} and #{year_range.last}"]
    end
  end

  @doc false
  def changeset(%Todo{} = todo, attrs, %Status{} = status, %User{} = user, categories) do
    # require IEx
    # IEx.pry()

    todo
    |> cast(attrs, [:name, :deadline, :description])
    |> validate_required([:name, :deadline])
    |> validate_change(:deadline, &year_inclusion_validator(&1, &2, get_valid_year_range()))
    |> validate_length(:description, count: :codepoints, max: get_string_character_limit())
    |> validate_length(:name, count: :codepoints, max: get_string_character_limit())
    |> unique_constraint(:name,
      name: :unique_todos_index,
      message: "A todo with the same name already exists"
    )
    |> put_assoc(:status, status)
    |> put_assoc(:user, user)
    |> put_assoc(:categories, categories)
  end

  # @doc false
  # def assign_status_to_todo_changeset(%Todo{} = todo, %Status{} = status) do
  #   todo
  #   |> cast(%{}, [])
  #   |> put_assoc(:status, status)
  # end
end
