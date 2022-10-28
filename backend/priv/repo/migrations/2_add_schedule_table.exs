defmodule TimeManager.Repo.Migrations.AddScheduleTable do
  use Ecto.Migration

  def change do
    create table(:schedules) do
      add(:weekday, :bigint)
      add(:endhour, :bigint)
      add(:starthour, :bigint)
      add(:endminute, :bigint)
      add(:startminute, :bigint)
      timestamps()
    end
  end
end
