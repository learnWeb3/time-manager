defmodule TimeManagerWeb.SessionController do
  use TimeManagerWeb, :controller
  alias TimeManager.Application

  action_fallback(TimeManagerWeb.FallbackController)

  def login(conn, %{"email" => email, "password" => password}) do
    token = Application.sign_in(email, password)
    session = %{token: token}

    conn
    |> put_status(:created)
    |> render("session.json", session: session)
  end
end
