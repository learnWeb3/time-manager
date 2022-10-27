defmodule TimeManagerWeb.WorkingTimeController do
  use TimeManagerWeb, :controller

  alias TimeManager.Application
  alias TimeManager.Application.WorkingTime

  plug(TimeManager.Plugs.Auth, "" when action in [:index, :create, :show, :update, :delete])

  action_fallback(TimeManagerWeb.FallbackController)

  def index(conn, params) do
    userId = Map.get(params, "userId", nil)
    startDate = Map.get(params, "start", nil)
    endDate = Map.get(params, "end", nil)
    working_times = Application.list_working_times(userId, startDate, endDate)
    render(conn, "index.json", working_times: working_times)
  end

  def create(conn, %{"userId" => userId, "working_time" => working_time_params}) do
    try do
      {userId, ""} = Integer.parse(userId)
      working_time = Application.create_working_time(userId, working_time_params)

      conn
      |> put_status(:created)
      |> render("show.json", working_time: working_time)
    rescue
      e ->
        error = %{message: Exception.message(e)}

        conn
        |> Plug.Conn.put_status(:bad_request)
        |> Phoenix.Controller.render(TimeManagerWeb.ErrorView, "error.json", error: error)
    end
  end

  def show(conn, %{"id" => id}) do
    working_time = Application.get_working_time!(id)
    render(conn, "show.json", working_time: working_time)
  end

  def update(conn, %{"id" => id, "working_time" => working_time_params}) do
    {id, ""} = Integer.parse(id)

    with {:ok, working_time} <- Application.update_working_time(id, working_time_params) do
      render(conn, "show.json", working_time: working_time)
    end
  end

  def delete(conn, %{"id" => id}) do
    working_time = Application.get_working_time!(id)

    with {:ok, %WorkingTime{}} <- Application.delete_working_time(working_time) do
      send_resp(conn, :no_content, "")
    end
  end
end
