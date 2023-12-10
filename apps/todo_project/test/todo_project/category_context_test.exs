defmodule TodoProject.CategoryContextTest do
  use TodoProject.DataCase

  alias TodoProject.CategoryContext

  describe "categories" do
    alias TodoProject.CategoryContext.Category

    import TodoProject.CategoryContextFixtures

    @invalid_attrs %{category: nil}

    test "list_categories/0 returns all categories" do
      category = category_fixture()
      assert CategoryContext.list_categories() == [category]
    end

    test "get_category!/1 returns the category with given id" do
      category = category_fixture()
      assert CategoryContext.get_category!(category.id) == category
    end

    test "create_category/1 with valid data creates a category" do
      valid_attrs = %{category: "some category"}

      assert {:ok, %Category{} = category} = CategoryContext.create_category(valid_attrs)
      assert category.category == "some category"
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CategoryContext.create_category(@invalid_attrs)
    end

    test "update_category/2 with valid data updates the category" do
      category = category_fixture()
      update_attrs = %{category: "some updated category"}

      assert {:ok, %Category{} = category} = CategoryContext.update_category(category, update_attrs)
      assert category.category == "some updated category"
    end

    test "update_category/2 with invalid data returns error changeset" do
      category = category_fixture()
      assert {:error, %Ecto.Changeset{}} = CategoryContext.update_category(category, @invalid_attrs)
      assert category == CategoryContext.get_category!(category.id)
    end

    test "delete_category/1 deletes the category" do
      category = category_fixture()
      assert {:ok, %Category{}} = CategoryContext.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> CategoryContext.get_category!(category.id) end
    end

    test "change_category/1 returns a category changeset" do
      category = category_fixture()
      assert %Ecto.Changeset{} = CategoryContext.change_category(category)
    end
  end
end
