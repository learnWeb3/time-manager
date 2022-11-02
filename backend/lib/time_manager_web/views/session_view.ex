defmodule TimeManagerWeb.SessionView do
  use TimeManagerWeb, :view
  alias TimeManagerWeb.SessionView

  def render("show.json", %{session: session}) do
    %{data: render_one(session, SessionView, "session.json")}
  end

  def render("session.json", %{session: session}) do
    user = session.user

    %{
      token: session.token,
      user: %{
        id: user.id,
        username: user.username,
        email: user.email,
        jobtitle: user.jobtitle,
        role: user.role
      }
    }
  end
end
