defmodule TimeManagerWeb.SessionController do
  use TimeManagerWeb, :controller
  alias TimeManager.Application

  action_fallback(TimeManagerWeb.FallbackController)

  def login(conn, %{"email" => email, "password" => password}) do
    try do
      token = Application.sign_in(email, password)
      session = %{token: token}

      conn
      |> put_status(:created)
      |> render("session.json", session: session)
    rescue
      e ->
        error = %{message: Exception.message(e)}

        conn
        |> put_status(:bad_request)
        |> render(TimeManagerWeb.ErrorView, "error.json", error: error)
    end
  end
end
