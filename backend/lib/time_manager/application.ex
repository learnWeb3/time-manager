defmodule TimeManager.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
  import Ecto.Query, only: [from: 2]
  alias TimeManager.Repo
  alias Elixir.BcryptElixir
  alias Elixir.Bcrypt
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      TimeManager.Repo,
      # Start the Telemetry supervisor
      TimeManagerWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: TimeManager.PubSub},
      # Start the Endpoint (http/https)
      TimeManagerWeb.Endpoint
      # Start a worker by calling: TimeManager.Worker.start_link(arg)
      # {TimeManager.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TimeManager.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TimeManagerWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  alias TimeManager.Application.User

  def encode_password(password) do
    Bcrypt.Base.hash_password(password, Bcrypt.Base.gen_salt(12, true))
  end

  def verify_user(password, stored_hash) do
    Bcrypt.verify_pass(password, stored_hash)
  end

  def verify_token(bearer_token) do
    TimeManager.Application.JwtToken.verify_and_validate!(bearer_token)
  end

  def sign_in(email, password) do
    user = Repo.get_by!(User, email: email)

    check = verify_user(password, user.password)

    if check do
      extra_claims = %{"sub" => user.id}
      TimeManager.Application.JwtToken.generate_and_sign!(extra_claims)
    else
      nil
    end
  end

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users(params) do
    email = Map.get(params, "email", nil)
    username = Map.get(params, "username", nil)

    cond do
      is_nil(email) and is_nil(username) ->
        query =
          from(user in User,
            order_by: [desc: user.inserted_at]
          )

        Repo.all(query)

      is_nil(email) and not is_nil(username) ->
        query =
          from(user in User,
            where: user.username == ^username,
            order_by: [desc: user.inserted_at]
          )

        Repo.all(query)

      not is_nil(email) and is_nil(username) ->
        query =
          from(user in User,
            where: user.email == ^email,
            order_by: [desc: user.inserted_at]
          )

        Repo.all(query)

      not is_nil(email) and not is_nil(username) ->
        query =
          from(user in User,
            where:
              user.email == ^email and
                user.username == ^username,
            order_by: [desc: user.inserted_at]
          )

        Repo.all(query)
    end
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    email = Map.get(attrs, "email")

    user_with_email = Repo.get_by(User, email: email)

    if is_nil(user_with_email) do
      plain_text_password = Map.get(attrs, "password")
      %{password_hash: hashed_password} = Bcrypt.add_hash(plain_text_password)
      attrs = Map.put(attrs, "password", hashed_password)

      %User{}
      |> User.changeset(attrs)
      |> Repo.insert()
    else
      raise UniqueConstraintError
    end
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    plain_text_password = Map.get(attrs, "password", nil)

    if not is_nil(plain_text_password) do
      %{password_hash: hashed_password} = Bcrypt.add_hash(plain_text_password)
      attrs = Map.put(attrs, "password", hashed_password)

      user
      |> User.changeset(attrs)
      |> Repo.update()
    else
      user
      |> User.changeset(attrs)
      |> Repo.update()
    end
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  alias TimeManager.Application.Clock

  @doc """
  Returns the list of clocks.

  ## Examples

      iex> list_clocks()
      [%Clock{}, ...]

  """
  def list_clocks do
    Repo.all(Clock)
  end

  @doc """
  Gets a single clock.

  Raises `Ecto.NoResultsError` if the Clock does not exist.

  ## Examples

      iex> get_clock!(123)
      %Clock{}

      iex> get_clock!(456)
      ** (Ecto.NoResultsError)

  """
  def get_clock!(id), do: Repo.get!(Clock, id)

  def get_user_clocks(userId) do
    query =
      from(clock in Clock, where: clock.user_id == ^userId, order_by: [desc: clock.inserted_at])

    Repo.all(query)
  end

  @doc """
  Creates a clock.

  ## Examples

      iex> create_clock(%{field: value})
      {:ok, %Clock{}}

      iex> create_clock(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_clock(userId, time, status) do
    user = get_user!(userId)

    clock = %Clock{
      user: user,
      time: time,
      status: status
    }

    Repo.insert!(clock)
  end

  @doc """
  Updates a clock.

  ## Examples

      iex> update_clock(clock, %{field: new_value})
      {:ok, %Clock{}}

      iex> update_clock(clock, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_clock(%Clock{} = clock, attrs) do
    clock
    |> Clock.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a clock.

  ## Examples

      iex> delete_clock(clock)
      {:ok, %Clock{}}

      iex> delete_clock(clock)
      {:error, %Ecto.Changeset{}}

  """
  def delete_clock(%Clock{} = clock) do
    Repo.delete(clock)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking clock changes.

  ## Examples

      iex> change_clock(clock)
      %Ecto.Changeset{data: %Clock{}}

  """
  def change_clock(%Clock{} = clock, attrs \\ %{}) do
    Clock.changeset(clock, attrs)
  end

  alias TimeManager.Application.WorkingTime

  @doc """
  Returns the list of working_times.

  ## Examples

      iex> list_working_times()
      [%WorkingTime{}, ...]

  """
  def list_working_times(userId, startDate, endDate) do
    cond do
      is_nil(startDate) and is_nil(endDate) ->
        query =
          from(workingtime in WorkingTime,
            where: workingtime.user_id == ^userId,
            order_by: [desc: workingtime.inserted_at]
          )

        Repo.all(query)

      is_nil(startDate) and String.length(endDate) > 0 ->
        {endDate, ""} = Integer.parse(endDate)

        query =
          from(workingtime in WorkingTime,
            where:
              workingtime.user_id == ^userId and
                workingtime.end >= ^endDate,
            order_by: [desc: workingtime.inserted_at]
          )

        Repo.all(query)

      String.length(startDate) > 0 and is_nil(endDate) ->
        {startDate, ""} = Integer.parse(startDate)

        query =
          from(workingtime in WorkingTime,
            where:
              workingtime.user_id == ^userId and
                workingtime.start >= ^startDate,
            order_by: [desc: workingtime.inserted_at]
          )

        Repo.all(query)

      String.length(startDate) > 0 and String.length(endDate) > 0 ->
        {endDate, ""} = Integer.parse(endDate)
        {startDate, ""} = Integer.parse(startDate)

        query =
          from(workingtime in WorkingTime,
            where:
              workingtime.user_id == ^userId and
                workingtime.start >= ^startDate and
                workingtime.end >= ^endDate,
            order_by: [desc: workingtime.inserted_at]
          )

        Repo.all(query)
    end
  end

  @doc """
  Gets a single working_time.

  Raises `Ecto.NoResultsError` if the Working time does not exist.

  ## Examples

      iex> get_working_time!(123)
      %WorkingTime{}

      iex> get_working_time!(456)
      ** (Ecto.NoResultsError)

  """
  def get_working_time!(id), do: Repo.get!(WorkingTime, id)

  @doc """
  Creates a working_time.

  ## Examples

      iex> create_working_time(%{field: value})
      {:ok, %WorkingTime{}}

      iex> create_working_time(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_working_time(userId, startDate, endDate) do
    user = get_user!(userId)

    working_time = %WorkingTime{
      user: user,
      start: startDate,
      end: endDate
    }

    Repo.insert!(working_time)
  end

  @doc """
  Updates a working_time.

  ## Examples

      iex> update_working_time(working_time, %{field: new_value})
      {:ok, %WorkingTime{}}

      iex> update_working_time(working_time, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_working_time(id, startDate, endDate) do
    IO.inspect(id)
    IO.inspect(startDate)
    IO.inspect(endDate)

    working_time = Repo.get_by(WorkingTime, id: id)

    cond do
      is_nil(startDate) and not is_nil(endDate) and is_integer(endDate) ->
        changeset = WorkingTime.changeset(working_time, %{end: endDate})
        Repo.update(changeset)

      is_nil(endDate) and not is_nil(startDate) and is_integer(startDate) ->
        changeset = WorkingTime.changeset(working_time, %{start: startDate})
        Repo.update(changeset)

      not is_nil(startDate) and is_integer(endDate) and not is_nil(endDate) and
          is_integer(endDate) ->
        changeset = WorkingTime.changeset(working_time, %{start: startDate, end: endDate})
        Repo.update(changeset)
    end
  end

  @doc """
  Deletes a working_time.

  ## Examples

      iex> delete_working_time(working_time)
      {:ok, %WorkingTime{}}

      iex> delete_working_time(working_time)
      {:error, %Ecto.Changeset{}}

  """
  def delete_working_time(%WorkingTime{} = working_time) do
    Repo.delete(working_time)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking working_time changes.

  ## Examples

      iex> change_working_time(working_time)
      %Ecto.Changeset{data: %WorkingTime{}}

  """
  def change_working_time(%WorkingTime{} = working_time, attrs \\ %{}) do
    WorkingTime.changeset(working_time, attrs)
  end
end
