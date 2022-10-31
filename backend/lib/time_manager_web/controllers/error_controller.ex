defmodule TimeManagerWeb.ErrorController do
  use TimeManagerWeb, :controller
  alias TimeManager.Application

  action_fallback(TimeManagerWeb.FallbackController)

  plug(TimeManager.Plugs.Auth, "" when action in [:create, :user_clocks])

  def not_found(conn, params) do
    error = %{message: "Not found"}

    conn
    |> put_status(:bad_request)
    |> render(TimeManagerWeb.ErrorView, "error.json", error: error)
  end
end
