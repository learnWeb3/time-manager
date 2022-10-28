defmodule TimeManager.Repo.Migrations.CreateClocks do
  use Ecto.Migration

  def change do
    create table(:clocks) do
      add :time, :bigint
      add :status, :boolean, default: false, null: false
      add :working_time_id, references(:working_times, on_delete: :nothing)

      timestamps()
    end

    create index(:clocks, [:working_time_id])
  end
end
