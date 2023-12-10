defmodule TodoProjectWeb.TodoApiController do
  use TodoProjectWeb, :controller

  alias TodoProject.TodoContext
  alias TodoProject.TodoContext.Todo
  alias TodoProject.StatusContext
  alias TodoProject.StatusContext.Status
  alias TodoProject.CategoryContext
  alias TodoProject.CategoryContext.Category
  alias TodoProject.UserContext
  alias TodoProject.UserContext.User
  alias TodoProjectWeb.Guardian

  action_fallback TodoProjectWeb.FallbackController

  def index(conn, _params) do
    todos = TodoContext.list_todos_preloaded()
    render(conn, "index.json", todos: todos)
  end

  def create(conn, %{"todo" => todo_params}) do
    # TODO fill in status, user, categories parameters
    with {:ok, %Todo{} = todo} <- TodoContext.create_todo(todo_params, %Status{}, %User{}, []) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.todo_api_path(conn, :show, todo))
      |> render("show.json", todo: todo)
    end
  end

  def show(conn, %{"id" => id}) do
    todo = TodoContext.get_todo!(id)
    render(conn, "show.json", todo: todo)
  end

  def update(conn, %{"id" => id, "todo" => todo_params}) do
    todo = TodoContext.get_todo!(id)

    # TODO fill in status, user, categories parameters
    with {:ok, %Todo{} = todo} <-
           TodoContext.update_todo(todo, todo_params, %Status{}, %User{}, []) do
      render(conn, "show.json", todo: todo)
    end
  end

  def delete(conn, %{"id" => id}) do
    todo = TodoContext.get_todo!(id)

    with {:ok, %Todo{}} <- TodoContext.delete_todo(todo) do
      send_resp(conn, :no_content, "")
    end
  end
end
