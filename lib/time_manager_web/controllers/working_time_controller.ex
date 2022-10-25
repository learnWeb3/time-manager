defmodule TimeManagerWeb.WorkingTimeController do
  use TimeManagerWeb, :controller

  alias TimeManager.Application
  alias TimeManager.Application.WorkingTime

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, _params) do
    working_times = Application.list_working_times()
    render(conn, "index.json", working_times: working_times)
  end

  def create(conn, %{"working_time" => working_time_params}) do
    with {:ok, %WorkingTime{} = working_time} <- Application.create_working_time(working_time_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.working_time_path(conn, :show, working_time))
      |> render("show.json", working_time: working_time)
    end
  end

  def show(conn, %{"id" => id}) do
    working_time = Application.get_working_time!(id)
    render(conn, "show.json", working_time: working_time)
  end

  def update(conn, %{"id" => id, "working_time" => working_time_params}) do
    working_time = Application.get_working_time!(id)

    with {:ok, %WorkingTime{} = working_time} <- Application.update_working_time(working_time, working_time_params) do
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
