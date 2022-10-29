defmodule TimeManagerWeb.PresenceView do
  use TimeManagerWeb, :view
  alias TimeManagerWeb.PresenceView

  def render("index.json", %{presences: presences}) do
    %{data: render_many(presences, PresenceView, "presence.json")}
  end

  def render("show.json", %{presence: presence}) do
    %{data: render_one(presence, PresenceView, "presence.json")}
  end

  def render("presence.json", %{presence: presence}) do
    %{
      duration: presence.duration,
      user_id: presence.user_id
    }
  end
end
