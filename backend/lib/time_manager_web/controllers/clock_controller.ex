defmodule TimeManagerWeb.ClockController do
  use TimeManagerWeb, :controller
  alias TimeManager.Application

  action_fallback(TimeManagerWeb.FallbackController)

  plug(TimeManager.Plugs.Auth, "" when action in [:create, :user_clocks])

  # check authorized_params
  plug(
    TimeManager.Plugs.AuthorizeParams,
    %{
      "userId" => true,
      "clock" => %{
        "time" => true
      }
    }
    when action in [:create]
  )

  plug(
    TimeManager.Plugs.AuthorizeParams,
    %{
      "userId" => true,
      "start" => true,
      "end" => true,
      "periodicity" => true
    }
    when action in [:presence]
  )

  plug(
    TimeManager.Plugs.AuthorizeParams,
    %{
      "userId" => true
    }
    when action in [:user_clocks]
  )

  # check required params
  plug(
    TimeManager.Plugs.RequireParams,
    %{
      "userId" => true,
      "clock" => %{
        "time" => true
      }
    }
    when action in [:create]
  )

  plug(
    TimeManager.Plugs.RequireParams,
    %{
      "userId" => true
    }
    when action in [:user_clocks]
  )

  # controller actions

  def presence(conn, params) do
    try do
      presences = Application.get_presence(params)

      conn
      |> put_status(:created)
      |> render(TimeManagerWeb.PresenceView, "index.json", presences: presences)
    rescue
      e ->
        error = %{message: Exception.message(e)}

        conn
        |> put_status(:bad_request)
        |> render(TimeManagerWeb.ErrorView, "error.json", error: error)
    end
  end

  def create(conn, %{"userId" => userId, "clock" => clock_params}) do
    try do
      clock = Application.create_clock(userId, clock_params)

      conn
      |> put_status(:created)
      |> render("show.json", clock: clock)
    rescue
      e ->
        error = %{message: Exception.message(e)}

        conn
        |> put_status(:bad_request)
        |> render(TimeManagerWeb.ErrorView, "error.json", error: error)
    end
  end

  def user_clocks(conn, params) do
    try do
      user_clocks = Application.get_user_clocks(params)
      render(conn, "index.json", clocks: user_clocks)
    rescue
      e ->
        error = %{message: Exception.message(e)}

        conn
        |> put_status(:bad_request)
        |> render(TimeManagerWeb.ErrorView, "error.json", error: error)
    end
  end
end
