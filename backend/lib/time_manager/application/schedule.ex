defmodule TimeManager.Application.Schedule do
  use Ecto.Schema
  import Ecto.Changeset

  schema "schedules" do
    field(:weekday, :integer)
    field(:endhour, :integer)
    field(:starthour, :integer)
    field(:endminute, :integer)
    field(:startminute, :integer)
    timestamps()
  end

  @doc false
  def changeset(clock, attrs) do
    clock
    |> cast(attrs, [:weekday, :starthour, :endhour, :startminute, :endminute])
    |> validate_required([:weekday, :starthour, :endhour, :startminute, :endminute])
    |> validate_number(:weekday, less_than: 7)
    |> validate_number(:starthour, less_than: 24)
    |> validate_number(:endhour, less_than: 24)
    |> validate_number(:startminute, greater_than: 0, less_than: 60)
    |> validate_number(:endminute, greater_than: 0, less_than: 60)
  end
end
