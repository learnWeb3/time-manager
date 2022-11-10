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
alias TimeManager.Application.User

try do
  roles = Role.get()

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

try do
  roles = Role.get()

  users = [
    %{
      "email" => "manager1@yopmail.com",
      "password" => "foobar",
      "role" => roles["manager"],
      "username" => "manager1",
      "jobtitle" => "manager1"
    },
    %{
      "email" => "manager2@yopmail.com",
      "password" => "foobar",
      "role" => roles["manager"],
      "username" => "manager2",
      "jobtitle" => "manager2"
    },
    %{
      "email" => "user1@yopmail.com",
      "password" => "foobar",
      "role" => roles["employee"],
      "username" => "user1",
      "jobtitle" => "user1"
    },
    %{
      "email" => "user2@yopmail.com",
      "password" => "foobar",
      "role" => roles["employee"],
      "username" => "user2",
      "jobtitle" => "user2"
    },
    %{
      "email" => "user3@yopmail.com",
      "password" => "foobar",
      "role" => roles["employee"],
      "username" => "user3",
      "jobtitle" => "user3"
    },
    %{
      "email" => "user4@yopmail.com",
      "password" => "foobar",
      "role" => roles["employee"],
      "username" => "user4",
      "jobtitle" => "user4"
    }
  ]

  Enum.map(users, fn user ->
    Application.create_user(user)
  end)
rescue
  e ->
    IO.puts("error while seeding fake users data " <> Exception.message(e))
end

try do
  last_year_second = 1_661_151_600

  users = Application.list_users(%{})

  Enum.map(users, fn %User{} = user ->
    Enum.each(0..100, fn day_number ->
      # arrival each day during a year
      arrival = last_year_second + day_number * 86400
      # duration of a shift between 1 and 12 hours
      shift_duration_hours = Enum.random(1..10)
      duration_seconds = shift_duration_hours * 3600
      # calculation of the time of departure
      departure = arrival + duration_seconds
      # clock in
      Application.create_clock(user.id, %{
        "time" => arrival
      })

      # clock out
      Application.create_clock(user.id, %{
        "time" => departure
      })
    end)
  end)
rescue
  e ->
    IO.puts("error while seeding fake schedule data " <> Exception.message(e))
end
