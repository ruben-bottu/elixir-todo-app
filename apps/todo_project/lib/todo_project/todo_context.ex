defmodule TodoProject.TodoContext do
  @moduledoc """
  The TodoContext context.
  """

  import Ecto.Query, warn: false
  alias TodoProject.Repo

  alias TodoProject.TodoContext.Todo
  alias TodoProject.StatusContext.Status
  alias TodoProject.UserContext.User
  alias TodoProject.CategoryContext.Category

  @behaviour Bodyguard.Policy

  def authorize(_func, %{role: "Admin"} = _user, _todo), do: :ok

  def authorize(:get_todo_preloaded!, %{id: user_id} = _user, %{user: %{id: user_id}} = _todo),
    do: :ok

  def authorize(:get_todo_preloaded!, _user, _todo), do: :error

  def categories_to_string(categories) when is_list(categories) do
    categories
    |> Enum.map(fn %Category{category: category} -> category end)
    |> Enum.join(", ")
  end

  def preload_todo(%Todo{} = todo) do
    Repo.preload(todo, [:status, :user, :categories])
  end

  @doc """
  Returns the list of todos.

  ## Examples

      iex> list_todos()
      [%Todo{}, ...]

  """
  def list_todos do
    Repo.all(Todo)
  end

  # Best practice: pass user as argument and preload their todos
  def list_todos_of_user_preloaded(id) do
    Repo.all(from t in Todo, where: t.user_id == ^id)
    |> Enum.map(&preload_todo/1)
  end

  def list_todos_preloaded do
    list_todos() |> Enum.map(&preload_todo/1)
  end

  # def list_todos do
  #   Repo.all(from t in Todo, preload: [:status])
  # end

  @doc """
  Gets a single todo.

  Raises `Ecto.NoResultsError` if the Todo does not exist.

  ## Examples

      iex> get_todo!(123)
      %Todo{}

      iex> get_todo!(456)
      ** (Ecto.NoResultsError)

  """
  def get_todo!(id), do: Repo.get!(Todo, id)

  def get_todo_preloaded!(id), do: get_todo!(id) |> preload_todo()

  def get_valid_year_range(), do: Todo.get_valid_year_range()

  @doc """
  Creates a todo.

  ## Examples

      iex> create_todo(%{field: value})
      {:ok, %Todo{}}

      iex> create_todo(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_todo(attrs, %Status{} = status, %User{} = user, categories)
      when is_list(categories) do
    %Todo{}
    |> Todo.changeset(attrs, status, user, categories)
    |> Repo.insert()
  end

  @doc """
  Updates a todo.

  ## Examples

      iex> update_todo(todo, %{field: new_value})
      {:ok, %Todo{}}

      iex> update_todo(todo, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_todo(%Todo{} = todo, attrs, %Status{} = status, %User{} = user, categories)
      when is_list(categories) do
    todo
    |> Todo.changeset(attrs, status, user, categories)
    |> Repo.update()
  end

  @doc """
  Deletes a todo.

  ## Examples

      iex> delete_todo(todo)
      {:ok, %Todo{}}

      iex> delete_todo(todo)
      {:error, %Ecto.Changeset{}}

  """
  def delete_todo(%Todo{} = todo) do
    Repo.delete(todo)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking todo changes.

  ## Examples

      iex> change_todo(todo)
      %Ecto.Changeset{data: %Todo{}}

  """
  def change_todo(
        %Todo{} = todo,
        attrs \\ %{},
        status \\ %Status{},
        user \\ %User{},
        categories \\ []
      ) do
    Todo.changeset(todo, attrs, status, user, categories)
  end
end
