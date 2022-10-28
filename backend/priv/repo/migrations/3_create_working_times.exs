defmodule TimeManager.Repo.Migrations.CreateWorkingTimes do
  use Ecto.Migration

  def change do
    create table(:working_times) do
      add(:user_id, references(:users, on_delete: :nothing))
      add(:schedule_id, references(:schedules, on_delete: :nothing))

      timestamps()
    end

    create(index(:working_times, [:user_id, :schedule_id]))
  end
end
