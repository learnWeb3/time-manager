defmodule TimeManagerWeb.ScheduleView do
  use TimeManagerWeb, :view
  alias TimeManagerWeb.ScheduleView

  def render("index.json", %{schedules: schedules}) do
    %{data: render_many(schedules, ScheduleView, "schedule.json")}
  end

  def render("show.json", %{schedule: schedule}) do
    %{data: render_one(schedule, ScheduleView, "schedule.json")}
  end

  def render("schedule.json", %{schedule: schedule}) do
    %{
      id: schedule.id,
      weekday: schedule.weekday,
      starthour: schedule.starthour,
      endhour: schedule.endhour,
      startminute: schedule.startminute,
      endminute: schedule.endminute
    }
  end
end
