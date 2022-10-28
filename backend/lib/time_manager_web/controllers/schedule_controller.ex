defmodule TimeManagerWeb.ScheduleController do
  use TimeManagerWeb, :controller
  alias TimeManager.Application

  action_fallback(TimeManagerWeb.FallbackController)

  plug(TimeManager.Plugs.Auth, "" when action in [:create, :update, :index])

  def index(conn, params) do
    try do
      startDate = Map.get(params, "start", nil)
      endDate = Map.get(params, "end", nil)
      schedules = Application.list_schedules(startDate, endDate)

      conn
      |> put_status(:created)
      |> render("index.json", schedules: schedules)
    rescue
      e ->
        error = %{message: Exception.message(e)}

        conn
        |> Plug.Conn.put_status(:bad_request)
        |> Phoenix.Controller.render(TimeManagerWeb.ErrorView, "error.json", error: error)
    end
  end

  def create(conn, %{"schedule" => schedule_params}) do
    try do
      schedule = Application.create_schedule(schedule_params)

      conn
      |> put_status(:created)
      |> render("show.json", schedule: schedule)
    rescue
      e ->
        error = %{message: Exception.message(e)}

        conn
        |> Plug.Conn.put_status(:bad_request)
        |> Phoenix.Controller.render(TimeManagerWeb.ErrorView, "error.json", error: error)
    end
  end

  def update(conn, %{"id" => id, "schedule" => schedule_params}) do
    try do
      schedule = Application.update_schedule(id, schedule_params)

      conn
      |> put_status(:created)
      |> render("show.json", schedule: schedule)
    rescue
      e ->
        error = %{message: Exception.message(e)}

        conn
        |> Plug.Conn.put_status(:bad_request)
        |> Phoenix.Controller.render(TimeManagerWeb.ErrorView, "error.json", error: error)
    end
  end

  def delete(conn, %{"id" => id}) do
    try do
      Application.delete_schedule(id)
      send_resp(conn, :no_content, "")
    rescue
      e ->
        error = %{message: Exception.message(e)}

        conn
        |> Plug.Conn.put_status(:bad_request)
        |> Phoenix.Controller.render(TimeManagerWeb.ErrorView, "error.json", error: error)
    end
  end
end
