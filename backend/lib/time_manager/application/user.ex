defmodule TimeManager.Application.User do
  alias TimeManager.Application.Role
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:email, :string)
    field(:jobtitle, :string)
    field(:username, :string)
    field(:password, :string)
    field(:role, :integer)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password, :jobtitle, :role])
    |> validate_required([:username, :email, :password, :role])
    |> validate_format(:email, ~r/^[\w-]+@[\w-]+\.[\w]+$/)
  end
end
