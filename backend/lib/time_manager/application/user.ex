defmodule TimeManager.Application.User do
  use Ecto.Schema
  import Ecto.Changeset
  # import TimeManager.Application.RoleHelper

  # default_user_role = Map.get(RoleHelper.find_role_by_name("employee"), "id", nil)

  schema "users" do
    field :email, :string
    field :jobtitle, :string
    field :username, :string
    field :password, :string
    # field :role, :integer, default: default_user_role

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password, :jobtitle])
    |> validate_required([:username, :email, :password])
    |> validate_format(:email, ~r/^[\w-]+@[\w-]+\.[\w]+$/)
  end
end
