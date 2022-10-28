defmodule TimeManager.Application.WorkingTime do
  use Ecto.Schema
  import Ecto.Changeset

  schema "working_times" do
    belongs_to(:user, TimeManager.Application.User)
    belongs_to(:schedule, TimeManager.Application.Schedule)

    timestamps()
  end

  @doc false
  def changeset(working_time, attrs) do
    working_time
    |> cast(attrs, [:schedule_id, :user_id])
    |> cast_assoc(:user)
    |> cast_assoc(:schedule)
  end
end
