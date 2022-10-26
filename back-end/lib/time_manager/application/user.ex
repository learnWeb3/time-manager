defmodule TimeManager.Application.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :username, :string
    field :password, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
<<<<<<< HEAD:back-end/lib/time_manager/application/user.ex
    |> cast(attrs, [:username, :email])
    |> validate_required([:username, :email])
    |> validate_format(:email, ~r/^[\w-]+@[\w-]+\.[\w]+$/)
=======
    |> cast(attrs, [:username, :email, :password])
    |> validate_required([:username, :email, :password])
>>>>>>> antoine:lib/time_manager/application/user.ex
  end
end
