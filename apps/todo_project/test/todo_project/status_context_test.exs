defmodule TodoProject.StatusContextTest do
  use TodoProject.DataCase

  alias TodoProject.StatusContext

  describe "statuses" do
    alias TodoProject.StatusContext.Status

    import TodoProject.StatusContextFixtures

    @invalid_attrs %{status: nil}

    test "list_statuses/0 returns all statuses" do
      status = status_fixture()
      assert StatusContext.list_statuses() == [status]
    end

    test "get_status!/1 returns the status with given id" do
      status = status_fixture()
      assert StatusContext.get_status!(status.id) == status
    end

    test "create_status/1 with valid data creates a status" do
      valid_attrs = %{status: "some status"}

      assert {:ok, %Status{} = status} = StatusContext.create_status(valid_attrs)
      assert status.status == "some status"
    end

    test "create_status/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = StatusContext.create_status(@invalid_attrs)
    end

    test "update_status/2 with valid data updates the status" do
      status = status_fixture()
      update_attrs = %{status: "some updated status"}

      assert {:ok, %Status{} = status} = StatusContext.update_status(status, update_attrs)
      assert status.status == "some updated status"
    end

    test "update_status/2 with invalid data returns error changeset" do
      status = status_fixture()
      assert {:error, %Ecto.Changeset{}} = StatusContext.update_status(status, @invalid_attrs)
      assert status == StatusContext.get_status!(status.id)
    end

    test "delete_status/1 deletes the status" do
      status = status_fixture()
      assert {:ok, %Status{}} = StatusContext.delete_status(status)
      assert_raise Ecto.NoResultsError, fn -> StatusContext.get_status!(status.id) end
    end

    test "change_status/1 returns a status changeset" do
      status = status_fixture()
      assert %Ecto.Changeset{} = StatusContext.change_status(status)
    end
  end
end
