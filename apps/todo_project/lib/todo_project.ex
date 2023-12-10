defmodule TodoProject do
  @moduledoc """
  TodoProject keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def get_string_character_limit(), do: 255

  def get_logged_in_user(%Plug.Conn{} = conn) do
    TodoProjectWeb.Guardian.Plug.current_resource(conn)
  end
end
