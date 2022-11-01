defmodule TimeManagerWeb.WorkingTimeController do
  use TimeManagerWeb, :controller

  alias TimeManager.Application
  alias TimeManager.Application.Role

  action_fallback(TimeManagerWeb.FallbackController)

  plug(TimeManager.Plugs.Auth, "" when action in [:index, :create, :show, :delete])

  # check user permission using token
  roles = Role.get()
  plug(TimeManager.Plugs.RoleGuard, [roles["admin"], roles["manager"]])

  # check authorized parameters

  plug(
    TimeManager.Plugs.AuthorizeParams,
    %{
      "working_time" => %{
        "schedule_id" => true
      },
      "userId" => true
    }
    when action in [:create]
  )

  plug(
    TimeManager.Plugs.AuthorizeParams,
    %{
      "id" => true
    }
    when action in [:delete]
  )

  plug(
    TimeManager.Plugs.AuthorizeParams,
    %{
      "userId" => true,
      "schedule_id" => true
    }
    when action in [:index]
  )

  # check required parameters

  plug(
    TimeManager.Plugs.RequireParams,
    %{
      "working_time" => %{
        "schedule_id" => true
      },
      "userId" => true
    }
    when action in [:create]
  )

  plug(
    TimeManager.Plugs.RequireParams,
    %{
      "id" => true
    }
    when action in [:delete]
  )

  plug(
    TimeManager.Plugs.RequireParams,
    %{
      "userId" => true
    }
    when action in [:index]
  )

  # controller actions

  def index(conn, params) do
    userId = Map.get(params, "userId", nil)
    scheduleId = Map.get(params, "schedule_id", nil)
    working_times = Application.list_working_times(userId, scheduleId)
    render(conn, "index.json", working_times: working_times)
  end

  def create(conn, %{"userId" => userId, "working_time" => working_time_params}) do
    try do
      {userId, ""} = Integer.parse(userId)
      working_time = Application.create_working_time(userId, working_time_params)

      conn
      |> put_status(:ok)
      |> render("show.json", working_time: working_time)
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
      Application.delete_working_time(id)
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
