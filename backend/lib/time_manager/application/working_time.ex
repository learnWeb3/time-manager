defmodule TimeManager.Application.WorkingTime do
  use Ecto.Schema
  import Ecto.Changeset

  schema "working_times" do
    field(:end, :integer)
    field(:start, :integer)
    belongs_to(:user, TimeManager.Application.User)

    timestamps()
  end

  @doc false
  def changeset(working_time, attrs) do
    working_time
    |> cast(attrs, [:start, :end, :user_id])
    |> cast_assoc(:user)
    |> validate_required([:start, :end])
  end
end
