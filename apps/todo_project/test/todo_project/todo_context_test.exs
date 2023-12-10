defmodule TodoProject.TodoContextTest do
  use TodoProject.DataCase

  alias TodoProject.TodoContext

  describe "todos" do
    alias TodoProject.TodoContext.Todo

    import TodoProject.TodoContextFixtures

    @invalid_attrs %{deadline: nil, description: nil, name: nil}

    test "list_todos/0 returns all todos" do
      todo = todo_fixture()
      assert TodoContext.list_todos() == [todo]
    end

    test "get_todo!/1 returns the todo with given id" do
      todo = todo_fixture()
      assert TodoContext.get_todo!(todo.id) == todo
    end

    test "create_todo/1 with valid data creates a todo" do
      valid_attrs = %{deadline: ~D[2022-05-19], description: "some description", name: "some name"}

      assert {:ok, %Todo{} = todo} = TodoContext.create_todo(valid_attrs)
      assert todo.deadline == ~D[2022-05-19]
      assert todo.description == "some description"
      assert todo.name == "some name"
    end

    test "create_todo/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = TodoContext.create_todo(@invalid_attrs)
    end

    test "update_todo/2 with valid data updates the todo" do
      todo = todo_fixture()
      update_attrs = %{deadline: ~D[2022-05-20], description: "some updated description", name: "some updated name"}

      assert {:ok, %Todo{} = todo} = TodoContext.update_todo(todo, update_attrs)
      assert todo.deadline == ~D[2022-05-20]
      assert todo.description == "some updated description"
      assert todo.name == "some updated name"
    end

    test "update_todo/2 with invalid data returns error changeset" do
      todo = todo_fixture()
      assert {:error, %Ecto.Changeset{}} = TodoContext.update_todo(todo, @invalid_attrs)
      assert todo == TodoContext.get_todo!(todo.id)
    end

    test "delete_todo/1 deletes the todo" do
      todo = todo_fixture()
      assert {:ok, %Todo{}} = TodoContext.delete_todo(todo)
      assert_raise Ecto.NoResultsError, fn -> TodoContext.get_todo!(todo.id) end
    end

    test "change_todo/1 returns a todo changeset" do
      todo = todo_fixture()
      assert %Ecto.Changeset{} = TodoContext.change_todo(todo)
    end
  end
end
