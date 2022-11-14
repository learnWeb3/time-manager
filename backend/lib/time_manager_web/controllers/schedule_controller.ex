defmodule TimeManagerWeb.ScheduleController do
  use TimeManagerWeb, :controller
  alias TimeManager.Application
  alias TimeManager.Application.Role
  alias TimeManager.Plugs.RateLimiter

  action_fallback(TimeManagerWeb.FallbackController)

  plug(TimeManager.Plugs.Auth, "")

  # configure rate limiting for the app
  plug(RateLimiter, %{
    "scale_ms" => 1000,
    "limit" => 50
  })

  # check user permission using token
  roles = Role.get()
  plug(TimeManager.Plugs.RoleGuard, [roles["admin"], roles["manager"]])

  # check authorized params

  plug(
    TimeManager.Plugs.AuthorizeParams,
    %{
      "schedule" => %{
        "endhour" => true,
        "endminute" => true,
        "starthour" => true,
        "startminute" => true,
        "weekday" => true
      }
    }
    when action in [:create]
  )

  plug(
    TimeManager.Plugs.AuthorizeParams,
    %{
      "id" => true,
      "schedule" => %{
        "endhour" => true,
        "endminute" => true,
        "starthour" => true,
        "startminute" => true,
        "weekday" => true
      }
    }
    when action in [:update]
  )

  plug(
    TimeManager.Plugs.AuthorizeParams,
    %{
      "id" => true
    }
    when action in [:delete]
  )

  # check required params

  plug(
    TimeManager.Plugs.RequireParams,
    %{
      "schedule" => %{
        "endhour" => true,
        "endminute" => true,
        "starthour" => true,
        "startminute" => true,
        "weekday" => true
      }
    }
    when action in [:create]
  )

  plug(
    TimeManager.Plugs.RequireParams,
    %{
      "id" => true,
      "schedule" => %{
        "endhour" => true,
        "endminute" => true,
        "starthour" => true,
        "startminute" => true,
        "weekday" => true
      }
    }
    when action in [:update]
  )

  plug(
    TimeManager.Plugs.RequireParams,
    %{
      "id" => true
    }
    when action in [:delete]
  )

  # controller actions

  def index(conn, _params) do
    try do
      schedules = Application.list_schedules()

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
