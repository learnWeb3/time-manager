defmodule TimeManager.Repo.Migrations.CreateClocks do
  use Ecto.Migration

  def change do
    create table(:clocks) do
      add :time, :bigint
      add :status, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :nothing)
      add :working_time_id, references(:working_times, on_delete: :nothing)

      timestamps()
    end

    create index(:clocks, [:user_id, :working_time_id])
  end
end
