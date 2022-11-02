defmodule TimeManagerWeb.StatusView do
  use TimeManagerWeb, :view
  alias TimeManagerWeb.StatusView

  def render("index.json", %{status: status}) do
    %{data: render_many(status, StatusView, "status.json")}
  end

  def render("show.json", %{status: status}) do
    %{data: render_one(status, StatusView, "status.json")}
  end

  def render("status.json", %{status: status}) do
    %{
      status: status["status"],
      userId: status["user_id"],
      time: status["time"],
    }
  end
end
