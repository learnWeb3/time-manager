defmodule TimeManager.Repo.Migrations.CreateWorkingTimes do
  use Ecto.Migration

  def change do
    create table(:working_times) do
      add :start, :bigint
      add :end, :bigint
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:working_times, [:user_id])
  end
end
