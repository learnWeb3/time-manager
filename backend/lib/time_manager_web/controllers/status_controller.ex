defmodule TimeManagerWeb.StatusController do
  use TimeManagerWeb, :controller
  alias TimeManager.Application

  action_fallback(TimeManagerWeb.FallbackController)

  plug(TimeManager.Plugs.Auth, "" when action in [:create, :user_clocks])

  plug(
    TimeManager.Plugs.AuthorizeParams,
    %{
      "userId" => true
    }
    when action in [:show]
  )

  # check required params
  plug(
    TimeManager.Plugs.RequireParams,
    %{
      "userId" => true
    }
    when action in [:show]
  )

  # controller actions

  def index(conn, _params) do
    try do
      users_status = Application.get_all_user_status()
      IO.inspect(users_status)
      render(conn, "index.json", status: users_status)
    rescue
      e ->
        error = %{message: Exception.message(e)}

        conn
        |> put_status(:bad_request)
        |> render(TimeManagerWeb.ErrorView, "error.json", error: error)
    end
  end

  def show(conn, params) do
    try do
      user_status = Application.get_user_status(params)
      render(conn, "show.json", status: user_status)
    rescue
      e ->
        error = %{message: Exception.message(e)}

        conn
        |> put_status(:bad_request)
        |> render(TimeManagerWeb.ErrorView, "error.json", error: error)
    end
  end
end
