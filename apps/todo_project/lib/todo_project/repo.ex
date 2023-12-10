defmodule TodoProject.Repo do
  use Ecto.Repo,
    otp_app: :todo_project,
    adapter: Ecto.Adapters.MyXQL
end
