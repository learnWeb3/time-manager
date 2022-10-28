defmodule TimeManagerWeb.UserController do
  use TimeManagerWeb, :controller

  alias TimeManager.Application
  alias TimeManager.Application.User
  alias TimeManager.Application.Role

  action_fallback(TimeManagerWeb.FallbackController)

  plug(TimeManager.Plugs.Auth, "" when action in [:create, :show, :update, :delete])

  # check user permission using token
  roles = Role.get()
  plug(TimeManager.Plugs.RoleGuard, [roles["admin"], roles["manager"]])

  def index(conn, params) do
    users = Application.list_users(params)
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    try do
      {:ok, user} = Application.create_user(user_params)

      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", user: user)
    rescue
      e ->
        error = %{message: Exception.message(e)}

        conn
        |> Plug.Conn.put_status(:bad_request)
        |> Phoenix.Controller.render(TimeManagerWeb.ErrorView, "error.json", error: error)
    end
  end

  def show(conn, %{"id" => id}) do
    try do
      user = Application.get_user!(id)
      render(conn, "show.json", user: user)
    rescue
      e ->
        error = %{message: Exception.message(e)}

        conn
        |> put_status(:bad_request)
        |> render(TimeManagerWeb.ErrorView, "error.json", error: error)
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    try do
      user = Application.get_user!(id)
      {:ok, user} = Application.update_user(user, user_params)
      render(conn, "show.json", user: user)
    rescue
      e ->
        error = %{message: Exception.message(e)}

        conn
        |> put_status(:bad_request)
        |> render(TimeManagerWeb.ErrorView, "error.json", error: error)
    end
  end

  def delete(conn, %{"id" => id}) do
    try do
      Application.delete_user(id)
      send_resp(conn, :no_content, "")
    rescue
      e ->
        error = %{message: Exception.message(e)}

        conn
        |> put_status(:bad_request)
        |> render(TimeManagerWeb.ErrorView, "error.json", error: error)
    end
  end
end
