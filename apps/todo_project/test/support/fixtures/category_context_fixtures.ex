defmodule TodoProject.CategoryContextFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TodoProject.CategoryContext` context.
  """

  @doc """
  Generate a category.
  """
  def category_fixture(attrs \\ %{}) do
    {:ok, category} =
      attrs
      |> Enum.into(%{
        category: "some category"
      })
      |> TodoProject.CategoryContext.create_category()

    category
  end
end
