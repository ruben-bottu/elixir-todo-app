defmodule TodoProjectWeb.FallbackController do
  use TodoProjectWeb, :controller

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:forbidden)
    |> put_view(TodoProjectWeb.ErrorView)
    |> render(:"403")
  end
end
