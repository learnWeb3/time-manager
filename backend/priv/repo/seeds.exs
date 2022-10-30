# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TimeManager.Repo.insert!(%TimeManager.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias TimeManager.Application
alias TimeManager.Application.Role

try do
  roles = Role.get()

  IO.inspect(roles)

  Application.create_user(%{
    "email" => "admin@yopmail.com",
    "password" => "foobar",
    "role" => roles["admin"],
    "username" => "admin",
    "jobtitle" => "admin"
  })

  IO.puts("Admin user registered using password: foobar and email: admin@yopmail.com")
rescue
  e ->
    IO.puts("error while seeding admin user " <> Exception.message(e))
end
