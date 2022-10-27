defmodule TimeManager.Application.WorkingTime do
  use Ecto.Schema
  import Ecto.Changeset

  schema "working_times" do
    field(:weekday, :integer)
    field(:endhour, :integer)
    field(:starthour, :integer)
    field(:endminute, :integer)
    field(:startminute, :integer)
    belongs_to(:user, TimeManager.Application.User)

    timestamps()
  end

  @doc false
  def changeset(working_time, attrs) do
    working_time
    |> cast(attrs, [:weekday, :starthour, :endhour, :startminute, :endminute, :user_id])
    |> cast_assoc(:user)
    |> validate_required([:weekday, :starthour, :endhour, :startminute, :endminute])
  end
end
