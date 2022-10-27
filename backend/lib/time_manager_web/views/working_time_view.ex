defmodule TimeManagerWeb.WorkingTimeView do
  use TimeManagerWeb, :view
  alias TimeManagerWeb.WorkingTimeView

  def render("index.json", %{working_times: working_times}) do
    %{data: render_many(working_times, WorkingTimeView, "working_time.json")}
  end

  def render("show.json", %{working_time: working_time}) do
    %{data: render_one(working_time, WorkingTimeView, "working_time.json")}
  end

  def render("working_time.json", %{working_time: working_time}) do
    %{
      id: working_time.id,
      weekday: working_time.weekday,
      starthour: working_time.starthour,
      endhour: working_time.endhour,
      startminute: working_time.startminute,
      endminute: working_time.endminute,
      user_id: working_time.user_id
    }
  end
end
