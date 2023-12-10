defmodule TodoProjectWeb.TodoApiView do
  use TodoProjectWeb, :view
  alias TodoProjectWeb.TodoApiView

  def render("index.json", %{todos: todos}) do
    require IEx
    IEx.pry()
    %{data: render_many(todos, TodoApiView, "todo.json")}
  end

  def render("show.json", %{todo: todo}) do
    require IEx
    IEx.pry()
    %{data: render_one(todo, TodoApiView, "todo.json")}
  end

  def render("todo.json", %{todo_api: todo}) do
    require IEx
    IEx.pry()

    %{
      id: todo.id,
      name: todo.name,
      deadline: todo.deadline,
      description: todo.description
    }
  end
end
