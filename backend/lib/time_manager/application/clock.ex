defmodule TimeManager.Application.Clock do
  use Ecto.Schema
  import Ecto.Changeset

  schema "clocks" do
    belongs_to(:user, TimeManager.Application.User)
    field(:status, :boolean, default: true)
    field(:time, :integer)
    timestamps()
  end

  @doc false
  def changeset(clock, attrs) do
    clock
    |> cast(attrs, [:status, :time, :user_id])
    |> cast_assoc(:user)
    |> validate_required([:time])
  end
end
