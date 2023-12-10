defmodule TodoProjectWeb.CategoryController do
  use TodoProjectWeb, :controller

  alias TodoProject.CategoryContext
  alias TodoProject.CategoryContext.Category

  def index(conn, _params) do
    categories = CategoryContext.list_categories()
    render(conn, "index.html", categories: categories)
  end

  def new(conn, _params) do
    changeset = CategoryContext.change_category(%Category{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"category" => category_params}) do
    case CategoryContext.create_category(category_params) do
      {:ok, category} ->
        conn
        |> put_flash(:info, "Category created successfully.")
        |> redirect(to: Routes.category_path(conn, :show, category))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    category = CategoryContext.get_category!(id)
    render(conn, "show.html", category: category)
  end

  def edit(conn, %{"id" => id}) do
    category = CategoryContext.get_category!(id)
    changeset = CategoryContext.change_category(category)
    render(conn, "edit.html", category: category, changeset: changeset)
  end

  def update(conn, %{"id" => id, "category" => category_params}) do
    category = CategoryContext.get_category!(id)

    case CategoryContext.update_category(category, category_params) do
      {:ok, category} ->
        conn
        |> put_flash(:info, "Category updated successfully.")
        |> redirect(to: Routes.category_path(conn, :show, category))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", category: category, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    category = CategoryContext.get_category!(id)
    {:ok, _category} = CategoryContext.delete_category(category)

    conn
    |> put_flash(:info, "Category deleted successfully.")
    |> redirect(to: Routes.category_path(conn, :index))
  end
end
