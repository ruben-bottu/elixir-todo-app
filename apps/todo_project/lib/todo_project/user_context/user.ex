defmodule TodoProject.UserContext.User do
  use Ecto.Schema
  import Ecto.Changeset
  import TodoProject, only: [get_string_character_limit: 0]
  alias TodoProject.TodoContext.Todo

  @acceptable_roles ["Admin", "Business Analyst", "User"]

  schema "users" do
    field :username, :string
    field :password, :string, virtual: true
    field :hashed_password, :string
    field :role, :string, default: "User"
    has_many :todos, Todo

    # timestamps()
  end

  def get_acceptable_roles, do: @acceptable_roles

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password, :role])
    |> validate_required([:username, :password, :role])
    |> validate_length(:username, count: :codepoints, max: get_string_character_limit())
    |> validate_length(:password, count: :codepoints, max: get_string_character_limit())
    |> validate_inclusion(:role, @acceptable_roles)
    |> unique_constraint(:username,
      name: :unique_users_index,
      message: "A user with the same username already exists"
    )
    |> put_password_hash()
  end

  def register_changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password])
    |> validate_required([:username, :password])
    |> validate_length(:username, count: :codepoints, max: get_string_character_limit())
    |> validate_length(:password, count: :codepoints, max: get_string_character_limit())
    |> unique_constraint(:username,
      name: :unique_users_index,
      message: "A user with the same username already exists"
    )
    |> put_password_hash()
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, hashed_password: Argon2.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset
end
