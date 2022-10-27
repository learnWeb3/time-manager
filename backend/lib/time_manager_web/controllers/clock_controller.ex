defmodule TimeManagerWeb.ClockController do
  use TimeManagerWeb, :controller
  alias TimeManager.Application

  action_fallback(TimeManagerWeb.FallbackController)

  plug(TimeManager.Plugs.Auth, "" when action in [:create, :user_clocks])

  def create(conn, %{"userId" => userId, "clock" => clock_params}) do
    {userId, ""} = Integer.parse(userId)
    time = Map.get(clock_params, "time", nil)
    status = Map.get(clock_params, "status", true)
    working_time_id = Map.get(clock_params, "working_time_id", nil)
    clock = Application.create_clock(userId, time, status, working_time_id)

    conn
    |> put_status(:created)
    |> render("show.json", clock: clock)
  end

  def user_clocks(conn, params) do
    try do
      user_clocks = Application.get_user_clocks(params)
      render(conn, "index.json", clocks: user_clocks)
    rescue
      e ->
        error = %{message: Exception.message(e)}

        conn
        |> put_status(:bad_request)
        |> render(TimeManagerWeb.ErrorView, "error.json", error: error)
    end
  end
end
