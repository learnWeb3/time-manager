defmodule TimeManager.Application.Clock do
  use Ecto.Schema
  import Ecto.Changeset

  schema "clocks" do
    belongs_to(:working_time, TimeManager.Application.WorkingTime)
    field(:status, :boolean, default: true)
    field(:time, :integer)
    timestamps()
  end

  @doc false
  def changeset(clock, attrs) do
    clock
    |> cast(attrs, [:status, :time, :working_time_id])
    |> cast_assoc(:working_time)
    |> validate_required([:time])
  end
end
