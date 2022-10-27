defmodule TimeManagerWeb.UserController do
  use TimeManagerWeb, :controller

  alias TimeManager.Application
  alias TimeManager.Application.User

  action_fallback(TimeManagerWeb.FallbackController)

  plug(TimeManager.Plugs.Auth, "" when action in [:create, :show, :update, :delete])

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
    user = Application.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Application.get_user!(id)

    with {:ok, %User{} = user} <- Application.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Application.get_user!(id)

    with {:ok, %User{}} <- Application.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
