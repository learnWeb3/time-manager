defmodule CronTask do
  alias TimeManager.Application

  # clock out every clocked in user and clock them in back
  # allowing for a better aggregation of user presence time
  # TO DO add a field in database allowing to differenciate a system generated clocks from a user generated clock
  def daily_clock_manager_clock_out do
    clocked_in_users = Application.get_clocked_in_users()
    Enum.map(clocked_in_users, fn %{"status" => status, "user_id" => user_id, "time" => time} ->
      # clock out the user that is still clocked in
      Application.create_clock(user_id, %{
        "time" => Application.get_unix_current_time()
      })

      # return user_id to reclock them in
      user_id
    end)
  end

  def daily_clock_manager_reclock_in(user_ids) do
    clocked_in_users = Application.get_clocked_in_users()

    Enum.map(user_ids, fn user_id ->
      # clock in the user back as it may not have yet finished working
      Application.create_clock(user_id, %{
        "time" => Application.get_unix_current_time()
      })
    end)
  end
end

clocked_in_users_ids = CronTask.daily_clock_manager_clock_out()
Process.sleep(10*60*1000)
CronTask.daily_clock_manager_reclock_in(clocked_in_users_ids)
