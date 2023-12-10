defmodule TodoProjectWeb.TodoApiControllerTest do
  use TodoProjectWeb.ConnCase

  import TodoProject.TodoApiContextFixtures

  alias TodoProject.TodoApiContext.TodoApi

  @create_attrs %{
    deadline: ~D[2022-08-13],
    description: "some description",
    name: "some name"
  }
  @update_attrs %{
    deadline: ~D[2022-08-14],
    description: "some updated description",
    name: "some updated name"
  }
  @invalid_attrs %{deadline: nil, description: nil, name: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all todoapis", %{conn: conn} do
      conn = get(conn, Routes.todo_api_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create todo_api" do
    test "renders todo_api when data is valid", %{conn: conn} do
      conn = post(conn, Routes.todo_api_path(conn, :create), todo_api: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.todo_api_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "deadline" => "2022-08-13",
               "description" => "some description",
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.todo_api_path(conn, :create), todo_api: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update todo_api" do
    setup [:create_todo_api]

    test "renders todo_api when data is valid", %{conn: conn, todo_api: %TodoApi{id: id} = todo_api} do
      conn = put(conn, Routes.todo_api_path(conn, :update, todo_api), todo_api: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.todo_api_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "deadline" => "2022-08-14",
               "description" => "some updated description",
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, todo_api: todo_api} do
      conn = put(conn, Routes.todo_api_path(conn, :update, todo_api), todo_api: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete todo_api" do
    setup [:create_todo_api]

    test "deletes chosen todo_api", %{conn: conn, todo_api: todo_api} do
      conn = delete(conn, Routes.todo_api_path(conn, :delete, todo_api))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.todo_api_path(conn, :show, todo_api))
      end
    end
  end

  defp create_todo_api(_) do
    todo_api = todo_api_fixture()
    %{todo_api: todo_api}
  end
end
