# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TodoProject.Repo.insert!(%TodoProject.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias TodoProject.StatusContext
# alias TodoProject.StatusContext.Status
alias TodoProject.CategoryContext
alias TodoProject.UserContext

##################################
######### Fill statuses ##########
##################################

status_data = [
  %{status: "Select a status"},
  %{status: "Needs action"},
  %{status: "Completed"},
  %{status: "In process"},
  %{status: "Cancelled"}
]

Enum.each(status_data, &StatusContext.create_status/1)

##################################
######### Fill categories ########
##################################

category_data = [
  %{category: "Garden"},
  %{category: "House"},
  %{category: "Groceries"},
  %{category: "School"},
  %{category: "Work"}
]

Enum.each(category_data, &CategoryContext.create_category/1)

#############################
######### Fill users ########
#############################

{:ok, _cs} = UserContext.create_user(%{"password" => "t", "role" => "User", "username" => "user"})

{:ok, _cs} =
  UserContext.create_user(%{
    "password" => "t",
    "role" => "Business Analyst",
    "username" => "businessanalyst"
  })

{:ok, _cs} =
  UserContext.create_user(%{"password" => "t", "role" => "Admin", "username" => "admin"})
