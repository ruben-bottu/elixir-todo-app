defmodule TodoProjectWeb.Plugs.LoggedInRolePlug do
  import Plug.Conn

  def init(options), do: options

  def call(conn, _options) do
    maybe_user = Guardian.Plug.current_resource(conn)

    if maybe_user do
      assign(conn, :logged_in_user_role, maybe_user.role)
    else
      assign(conn, :logged_in_user_role, nil)
    end
  end
end
