defmodule TimeManagerWeb.StatusController do
  use TimeManagerWeb, :controller
  alias TimeManager.Application
  alias TimeManager.Application.Role
  alias TimeManager.Plugs.RateLimiter

  action_fallback(TimeManagerWeb.FallbackController)

  # authenticate user
  plug(TimeManager.Plugs.Auth, "")

  # configure rate limiting for the app
  plug(RateLimiter, %{
    "scale_ms" => 1000,
    "limit" => 50
  })

  # check user permission using token
  roles = Role.get()

  plug(TimeManager.Plugs.RoleGuard, [roles["admin"], roles["manager"]] when action in [:index])

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
      user_id = Map.get(params, "userId", nil)
      Application.owner_manager_or_admin!(conn.current_user, user_id)
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
