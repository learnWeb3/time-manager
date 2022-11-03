defmodule CronTask do
  alias TimeManager.Application

  # clock out every clocked in user and clock them in back
  # allowing for a better aggregation of user presence time
  # TO DO add a field in database allowing to differenciate a system generated clocks from a user generated clock
  def daily_clock_manager do
    clocked_in_users = Application.get_clocked_in_users()

    Enum.map(clocked_in_users, fn %{"status" => status, "user_id" => user_id, "time" => time} ->
      # clock out the user that is still clocked in
      Application.create_clock(user_id, %{
        "time" => Application.get_unix_current_time()
      })

      Process.sleep(1000)

      # clock in the user back as it may not have yet finished working
      Application.create_clock(user_id, %{
        "time" => Application.get_unix_current_time()
      })

      Process.sleep(1000)
    end)
  end
end

CronTask.daily_clock_manager()
