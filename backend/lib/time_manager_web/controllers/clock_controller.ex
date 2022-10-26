defmodule TimeManagerWeb.ClockController do
  use TimeManagerWeb, :controller
  alias TimeManager.Application

  action_fallback(TimeManagerWeb.FallbackController)

  plug(TimeManager.Plugs.Auth, "" when action in [:create, :user_clocks])

  def create(conn, %{"userId" => userId, "clock" => clock_params}) do
    {userId, ""} = Integer.parse(userId)
    time = Map.get(clock_params, "time")
    status = Map.get(clock_params, "status", true)
    clock = Application.create_clock(userId, time, status)

    conn
    |> put_status(:created)
    |> render("show.json", clock: clock)
  end

  def user_clocks(conn, %{"userId" => userId}) do
    user_clocks = Application.get_user_clocks(userId)
    render(conn, "index.json", clocks: user_clocks)
  end
end
