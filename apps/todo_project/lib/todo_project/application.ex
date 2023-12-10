defmodule TodoProject.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      TodoProject.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: TodoProject.PubSub}
      # Start a worker by calling: TodoProject.Worker.start_link(arg)
      # {TodoProject.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: TodoProject.Supervisor)
  end
end
