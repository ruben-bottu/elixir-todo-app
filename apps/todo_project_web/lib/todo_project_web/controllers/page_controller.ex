defmodule TodoProjectWeb.PageController do
  use TodoProjectWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html", role: "everyone")
  end

  def user_index(conn, _params) do
    render(conn, "index.html", role: "users")
  end

  def business_analyst_index(conn, _params) do
    render(conn, "index.html", role: "business analyst")
  end

  def admin_index(conn, _params) do
    render(conn, "index.html", role: "admins")
  end
end
