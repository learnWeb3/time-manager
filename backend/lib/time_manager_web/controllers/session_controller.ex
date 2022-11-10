defmodule TimeManagerWeb.SessionController do
  use TimeManagerWeb, :controller
  alias TimeManager.Application

  action_fallback(TimeManagerWeb.FallbackController)

  # check authorized parameters

  plug(
    TimeManager.Plugs.AuthorizeParams,
    %{
      "email" => true,
      "password" => true
    }
    when action in [:login]
  )

  # check required parameters

  plug(
    TimeManager.Plugs.RequireParams,
    %{
      "email" => true,
      "password" => true
    }
    when action in [:login]
  )

  # controller actions

  def login(conn, %{"email" => email, "password" => password}) do
    try do
      sign_in_claim = Application.sign_in(email, password)

      conn
      |> put_status(:created)
      |> render("session.json", session: sign_in_claim)
    rescue
      e ->
        error = %{message: Exception.message(e)}

        conn
        |> put_status(:bad_request)
        |> render(TimeManagerWeb.ErrorView, "error.json", error: error)
    end
  end
end
