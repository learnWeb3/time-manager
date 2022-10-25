defmodule TimeManagerWeb.ClockController do
  use TimeManagerWeb, :controller
  alias TimeManager.Application

  action_fallback(TimeManagerWeb.FallbackController)

  # def index(conn, _params) do
  #   clocks = Application.list_clocks()
  #   render(conn, "index.json", clocks: clocks)
  # end

  def create(conn, %{"userId" => userId, "clock" => clock_params}) do
    {userId, ""} = Integer.parse(userId)
    time = Map.get(clock_params, "time");
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

  # def update(conn, %{"id" => id, "clock" => clock_params}) do
  #   clock = Application.get_clock!(id)

  #   with {:ok, %Clock{} = clock} <- Application.update_clock(clock, clock_params) do
  #     render(conn, "show.json", clock: clock)
  #   end
  # end

  # def delete(conn, %{"id" => id}) do
  #   clock = Application.get_clock!(id)

  #   with {:ok, %Clock{}} <- Application.delete_clock(clock) do
  #     send_resp(conn, :no_content, "")
  #   end
  # end
end
