defmodule TimeManager.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:username, :string)
      add(:email, :string)
      add(:password, :string)
      add(:jobtitle, :string)
      add(:role, :integer)

      timestamps()
    end
  end
end
