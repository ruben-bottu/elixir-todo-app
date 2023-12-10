defmodule TodoProject.StatusContextFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TodoProject.StatusContext` context.
  """

  @doc """
  Generate a status.
  """
  def status_fixture(attrs \\ %{}) do
    {:ok, status} =
      attrs
      |> Enum.into(%{
        status: "some status"
      })
      |> TodoProject.StatusContext.create_status()

    status
  end
end
