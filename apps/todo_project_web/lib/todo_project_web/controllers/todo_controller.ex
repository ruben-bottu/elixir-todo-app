defmodule TodoProjectWeb.TodoController do
  use TodoProjectWeb, :controller

  alias TodoProject.TodoContext
  alias TodoProject.TodoContext.Todo
  alias TodoProject.StatusContext
  alias TodoProject.StatusContext.Status
  alias TodoProject.CategoryContext
  alias TodoProject.CategoryContext.Category
  alias TodoProjectWeb.Guardian

  def give_common_attributes(
        %Ecto.Changeset{} = changeset,
        %Status{} = current_status,
        current_categories
      )
      when is_list(current_categories) do
    [
      changeset: changeset,
      year_range: TodoContext.get_valid_year_range(),
      statuses: StatusContext.list_statuses(),
      current_status_id: current_status.id,
      categories: CategoryContext.list_categories(),
      current_category_ids: Enum.map(current_categories, fn %Category{id: id} -> id end)
    ]
  end

  def index(conn, _params) do
    logged_in_user = TodoProject.get_logged_in_user(conn)
    todos = TodoContext.list_todos_of_user_preloaded(logged_in_user.id)
    render(conn, "index.html", todos: todos)
  end

  defp render_new_html(%Plug.Conn{} = conn, %Ecto.Changeset{} = changeset) do
    default_status = StatusContext.get_default()
    render(conn, "new.html", give_common_attributes(changeset, default_status, []))
  end

  def new(conn, _params) do
    changeset =
      %Todo{}
      |> TodoContext.preload_todo()
      |> TodoContext.change_todo()

    render_new_html(conn, changeset)
  end

  defp todo_params_to_status_and_categories(%{"status_id" => status_id} = todo_params) do
    status = StatusContext.get_status!(status_id)

    categories =
      todo_params |> Map.get("category_ids", []) |> Enum.map(&CategoryContext.get_category!/1)

    {status, categories}
  end

  def create(conn, %{"todo" => todo_params}) do
    # require IEx
    # IEx.pry()
    {status, categories} = todo_params_to_status_and_categories(todo_params)
    logged_in_user = Guardian.Plug.current_resource(conn)

    case TodoContext.create_todo(todo_params, status, logged_in_user, categories) do
      {:ok, todo} ->
        conn
        |> put_flash(:info, "Todo created successfully.")
        |> redirect(to: Routes.todo_path(conn, :show, todo))

      {:error, %Ecto.Changeset{} = changeset} ->
        render_new_html(conn, changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    logged_in_user = Guardian.Plug.current_resource(conn)
    todo = TodoContext.get_todo_preloaded!(id)
    Bodyguard.permit!(TodoContext, :get_todo_preloaded!, logged_in_user, todo)

    render(conn, "show.html",
      todo: todo,
      categories_string: TodoContext.categories_to_string(todo.categories)
    )
  end

  defp render_edit_html(%Plug.Conn{} = conn, %Todo{} = todo, %Ecto.Changeset{} = changeset) do
    render(conn, "edit.html", [
      {:todo, todo} | give_common_attributes(changeset, todo.status, todo.categories)
    ])
  end

  def edit(conn, %{"id" => id}) do
    logged_in_user = Guardian.Plug.current_resource(conn)
    todo = TodoContext.get_todo_preloaded!(id)
    Bodyguard.permit!(TodoContext, :get_todo_preloaded!, logged_in_user, todo)
    changeset = TodoContext.change_todo(todo)

    render_edit_html(conn, todo, changeset)
  end

  def update(conn, %{"id" => id, "todo" => todo_params}) do
    logged_in_user = Guardian.Plug.current_resource(conn)
    todo = TodoContext.get_todo_preloaded!(id)
    Bodyguard.permit!(TodoContext, :get_todo_preloaded!, logged_in_user, todo)
    {status, categories} = todo_params_to_status_and_categories(todo_params)
    logged_in_user = Guardian.Plug.current_resource(conn)

    case TodoContext.update_todo(todo, todo_params, status, logged_in_user, categories) do
      {:ok, todo} ->
        conn
        |> put_flash(:info, "Todo updated successfully.")
        |> redirect(to: Routes.todo_path(conn, :show, todo))

      {:error, %Ecto.Changeset{} = changeset} ->
        render_edit_html(conn, todo, changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    todo = TodoContext.get_todo!(id)

    case TodoContext.delete_todo(todo) do
      {:ok, _todo} ->
        conn
        |> put_flash(:info, "Todo deleted successfully.")
        |> redirect(to: Routes.todo_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn |> put_flash(:error, changeset)
        index(conn, nil)
    end
  end
end
