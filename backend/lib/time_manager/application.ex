defmodule TimeManager.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
  import Ecto.Query
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
  alias TimeManager.Application.Schedule
  alias TimeManager.Application.Clock
  alias TimeManager.Application.WorkingTime

  # ========= PRSENCE ===========

  def get_unix_current_time do
    {:ok, current_datetime} = DateTime.now("Etc/UTC")
    DateTime.to_unix(current_datetime, :second)
  end

  def calculate_presence_duration_from_sums(departure_sums, arrival_sums) do
    # add a tuple {unix_datetime, userId} if user is still working (has not left yet)
    if Kernel.length(departure_sums) < Kernel.length(arrival_sums) do
      {_arrival_sum, userId} = List.first(arrival_sums)
      # slow - check for impact to prepend instead of append as ++ has a 0(n) complexity
      unix_datetime = get_unix_current_time()
      departure_sums = departure_sums ++ [{unix_datetime, userId, 0}]

      Enum.with_index(departure_sums, fn departure_sum, index ->
        {departure_sum, userId, periodicity} = departure_sum
        {arrival_sum, userId, periodicity} = Enum.at(arrival_sums, index)

        %{duration: departure_sum - arrival_sum, user_id: userId, periodicity: periodicity}
      end)
    else
      Enum.with_index(departure_sums, fn departure_sum, index ->
        {departure_sum, userId, periodicity} = departure_sum
        {arrival_sum, userId, periodicity} = Enum.at(arrival_sums, index)

        %{duration: departure_sum - arrival_sum, user_id: userId, periodicity: periodicity}
      end)
    end
  end

  def build_presence_query(%{
        "userId" => userId,
        "startDatetime" => startDatetime,
        "endDatetime" => endDatetime,
        "status" => status,
        "periodicity" => periodicity
      }) do
    if is_nil(userId) do
      if is_nil(periodicity) do
        query =
          from(clock in Clock,
            select: {
              sum(clock.time),
              clock.user_id,
              0
            },
            where:
              clock.status == ^status and
                clock.inserted_at >= ^startDatetime and
                clock.inserted_at <= ^endDatetime,
            group_by: [
              clock.user_id
            ]
          )

        Repo.all(query)
      else
        query = """
        SELECT
        SUM(clocks.time),
        clocks.user_id,
        TO_CHAR(TO_TIMESTAMP(clocks.time), $1) as periodicity
        FROM clocks
        WHERE clocks.status = $2
        AND clocks.inserted_at >= $3
        AND clocks.inserted_at <= $4
        GROUP BY clocks.user_id, TO_CHAR(TO_TIMESTAMP(clocks.time), $1)
        """

        params = [periodicity, status, startDatetime, endDatetime]

        {:ok, result} =
          Repo.query(
            query,
            params
          )

        Enum.map(result.rows, fn [sum, userId, periodicity] -> {sum, userId, periodicity} end)
      end
    else
      if is_nil(periodicity) do
        query =
          from(clock in Clock,
            select: {
              sum(clock.time),
              clock.user_id,
              0
            },
            where:
              clock.user_id ==
                ^userId and
                clock.status == ^status and
                clock.inserted_at >= ^startDatetime and
                clock.inserted_at <= ^endDatetime,
            group_by: [
              clock.user_id
            ]
          )

        Repo.all(query)
      else
        query = """
        SELECT
        SUM(clocks.time),
        clocks.user_id,
        TO_CHAR(TO_TIMESTAMP(clocks.time), $1) as periodicity
        FROM clocks
        WHERE clocks.user_id = $2::integer
        AND clocks.status = $3
        AND clocks.inserted_at >= $4
        AND clocks.inserted_at <= $5
        GROUP BY clocks.user_id, TO_CHAR(TO_TIMESTAMP(clocks.time), $1)
        """

        {userId, _} = Integer.parse(userId)
        params = [periodicity, userId, status, startDatetime, endDatetime]

        {:ok, result} =
          Repo.query(
            query,
            params
          )

        Enum.map(result.rows, fn [sum, userId, periodicity] -> {sum, userId, periodicity} end)
      end
    end
  end

  def get_presence(params) do
    userId = Map.get(params, "userId", nil)
    unix_datetime = get_unix_current_time()
    year_in_seconds = 365 * 24 * 60 * 60

    # one of : [global, day, week, month] default to global
    available_periodicity = %{
      "global" => nil,
      # day name
      "dayname" => "dy",
      # day of the month
      "dayofmonth" => "DD",
      # day of the year
      "dayoftheyear" => "DDD",
      # day
      "day" => "DD:MM:YYYY",
      # week number
      "week" => "WW",
      # month name
      "month" => "mon",
      # year
      "year" => "YYYY"
    }

    periodicity = Map.get(params, "periodicity", "global")
    startDate = Map.get(params, "start", unix_datetime - year_in_seconds)
    # default to current datetime in seconds
    endDate = Map.get(params, "end", unix_datetime)

    startDatetime = DateTime.to_naive(DateTime.from_unix!(startDate))
    endDatetime = DateTime.to_naive(DateTime.from_unix!(endDate))

    current_periodicity = Map.get(available_periodicity, periodicity)

    departure_query_params = %{
      "userId" => userId,
      "startDatetime" => startDatetime,
      "endDatetime" => endDatetime,
      "status" => false,
      "periodicity" => current_periodicity
    }

    departure_sums = build_presence_query(departure_query_params)

    IO.inspect(departure_sums)

    arrival_query_params = %{
      "userId" => userId,
      "startDatetime" => startDatetime,
      "endDatetime" => endDatetime,
      "status" => true,
      "periodicity" => current_periodicity
    }

    arrival_sums = build_presence_query(arrival_query_params)
    IO.inspect(arrival_sums)

    calculate_presence_duration_from_sums(departure_sums, arrival_sums)
  end

  # =========  USERS ============
  def encode_password(password) do
    Bcrypt.Base.hash_password(password, Bcrypt.Base.gen_salt(12, true))
  end

  def verify_user(password, stored_hash) do
    Bcrypt.verify_pass(password, stored_hash)
  end

  def verify_token(bearer_token) do
    try do
      TimeManager.Application.JwtToken.verify_and_validate!(bearer_token)
    rescue
      _e ->
        raise JWTMissingTokenError
    end
  end

  def sign_in(email, password) do
    user = Repo.get_by(User, email: email)

    if is_nil(user) do
      raise NotFoundError, message: "invalid credentials"
    end

    check = verify_user(password, user.password)

    if check do
      extra_claims = %{"sub" => user.id}
      TimeManager.Application.JwtToken.generate_and_sign!(extra_claims)
    else
      raise ValidationError, message: "invalid credentials"
    end
  end

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

  def get_user!(id) do
    user = Repo.get(User, id)

    if is_nil(user) do
      raise NotFoundError, message: "user not found for user with id " <> id
    else
      user
    end
  end

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

  def delete_user(id) do
    user = Repo.get(User, id)
    # check for relations existences to send proper errors
    # - working_times

    query =
      from(working_time in WorkingTime,
        where: working_time.user_id == ^id
      )

    user_working_times = Repo.all(query)

    if Kernel.length(user_working_times) > 0 do
      raise ValidationError, message: "user possess working_times and thus can not be deleted"
    end

    if is_nil(user) do
      raise NotFoundError, message: "user does not exists with id " <> id
    end

    Repo.delete(user)
  end

  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  # =========  CLOCKS ============

  def list_clocks do
    Repo.all(Clock)
  end

  def get_clock!(id), do: Repo.get!(Clock, id)

  def get_user_clocks(params) do
    userId = Map.get(params, "userId", nil)
    user = Repo.get_by(User, id: userId)

    if is_nil(user) do
      raise NotFoundError, message: "user not found for user with id " <> userId
    else
      query =
        from(clock in Clock,
          where: clock.user_id == ^userId,
          order_by: [desc: clock.inserted_at]
        )

      Repo.all(query)
    end
  end

  def get_user_last_clocks(userId, limit) do
    query =
      from(clock in Clock,
        where: clock.user_id == ^userId,
        order_by: [desc: clock.inserted_at],
        limit: ^limit
      )

    Repo.all(query)
  end

  def create_clock(userId, clock_params) do
    time = Map.get(clock_params, "time", nil)
    user = Repo.get(User, userId)

    if is_nil(user) do
      raise NotFoundError,
        message: "user does not exists using id " <> userId
    end

    last_user_clock = List.first(get_user_last_clocks(userId, 1), nil)

    if is_nil(last_user_clock) do
      clock = %Clock{
        time: time,
        status: true,
        user: user
      }

      Repo.insert!(clock)
    else
      status = Map.get(last_user_clock, :status)

      clock = %Clock{
        time: time,
        status: not status,
        user: user
      }

      Repo.insert!(clock)
    end
  end

  def update_clock(%Clock{} = clock, attrs) do
    clock
    |> Clock.changeset(attrs)
    |> Repo.update()
  end

  def delete_clock(%Clock{} = clock) do
    Repo.delete(clock)
  end

  def change_clock(%Clock{} = clock, attrs \\ %{}) do
    Clock.changeset(clock, attrs)
  end

  # =========  WORKING_TIMES ============

  def list_working_times(userId, scheduleId) do
    cond do
      is_nil(userId) and is_nil(scheduleId) ->
        query =
          from(working_time in WorkingTime,
            order_by: [desc: working_time.inserted_at]
          )

        Repo.all(query)

      is_nil(userId) and not is_nil(scheduleId) ->
        query =
          from(working_time in WorkingTime,
            where: working_time.schedule_id == ^scheduleId,
            order_by: [desc: working_time.inserted_at]
          )

        Repo.all(query)

      not is_nil(userId) and is_nil(scheduleId) ->
        query =
          from(working_time in WorkingTime,
            where: working_time.user_id == ^userId,
            order_by: [desc: working_time.inserted_at]
          )

        Repo.all(query)

      not is_nil(userId) and not is_nil(scheduleId) ->
        query =
          from(working_time in WorkingTime,
            where:
              working_time.user_id == ^userId and
                working_time.schedule_id == ^scheduleId,
            order_by: [desc: working_time.inserted_at]
          )

        Repo.all(query)
    end
  end

  def get_working_time!(id) do
    working_time = Repo.get(WorkingTime, id)

    if is_nil(working_time) do
      raise NotFoundError, message: "working time does not exists using id " <> id
    end
  end

  def create_working_time(userId, working_time_params) do
    user = get_user!(userId)

    schedule_id = Map.get(working_time_params, "schedule_id", nil)

    if is_nil(schedule_id) do
      raise ValidationError, message: "Missing body parameter working_time_id"
    end

    schedule = Repo.get(Schedule, schedule_id)

    if is_nil(schedule) do
      raise NotFoundError, message: "Schedule does not exists"
    end

    query =
      from(working_time in WorkingTime,
        where: working_time.user_id == ^userId and working_time.schedule_id == ^schedule_id,
        order_by: [desc: working_time.inserted_at]
      )

    working_times = Repo.all(query)

    if Kernel.length(working_times) > 0 do
      raise ValidationError,
        message:
          "user with id " <>
            Integer.to_string(userId) <>
            " has already registered for schedule with id " <> Integer.to_string(schedule_id)
    end

    new_working_time = %WorkingTime{
      user: user,
      schedule: schedule
    }

    {:ok, new_working_time} = Repo.insert(new_working_time)
    new_working_time
  end

  def delete_working_time(id) do
    # check for relations existences to send proper errors
    # - schedule

    working_time = Repo.get(WorkingTime, id)

    if is_nil(working_time) do
      raise NotFoundError, message: "working time does not exists using id" <> id
    end

    Repo.delete(working_time)
  end

  def change_working_time(%WorkingTime{} = working_time, attrs \\ %{}) do
    WorkingTime.changeset(working_time, attrs)
  end

  # =========  SCHEDULES  ============
  def list_schedules(startDate, endDate) do
    cond do
      is_nil(startDate) and is_nil(endDate) ->
        query =
          from(schedule in Schedule,
            order_by: [desc: schedule.inserted_at]
          )

        Repo.all(query)

      is_nil(startDate) and String.length(endDate) > 0 ->
        {endDate, ""} = Integer.parse(endDate)

        query =
          from(schedule in Schedule,
            where: schedule.end >= ^endDate,
            order_by: [desc: schedule.inserted_at]
          )

        Repo.all(query)

      String.length(startDate) > 0 and is_nil(endDate) ->
        {startDate, ""} = Integer.parse(startDate)

        query =
          from(schedule in Schedule,
            where: schedule.start >= ^startDate,
            order_by: [desc: schedule.inserted_at]
          )

        Repo.all(query)

      String.length(startDate) > 0 and String.length(endDate) > 0 ->
        {endDate, ""} = Integer.parse(endDate)
        {startDate, ""} = Integer.parse(startDate)

        query =
          from(schedule in Schedule,
            where:
              schedule.start >= ^startDate and
                schedule.end >= ^endDate,
            order_by: [desc: schedule.inserted_at]
          )

        Repo.all(query)
    end
  end

  def update_schedule(id, schedule_params) do
    schedule = Repo.get(Schedule, id)

    if is_nil(schedule) do
      raise NotFoundError, message: "schedule does not exists using id " <> id
    end

    changeset = Schedule.changeset(schedule, schedule_params)
    {:ok, updated_schedule} = Repo.update(changeset)
    updated_schedule
  end

  def create_schedule(schedule_params) do
    schedule = %Schedule{}
    changeset = Schedule.changeset(schedule, schedule_params)
    Repo.insert!(changeset)
  end

  def delete_schedule(id) do
    schedule = Repo.get(Schedule, id)

    if is_nil(schedule) do
      raise NotFoundError, message: "schedule does not exists using id " <> id
    end

    # check relations existence to send proper messages
    query =
      from(working_time in WorkingTime,
        where: working_time.schedule_id == ^id
      )

    schedule_working_times = Repo.all(query)

    if Kernel.length(schedule_working_times) > 0 do
      raise ValidationError,
        message: "schedule possess related working times and thus can not be deleted"
    end

    Repo.delete(schedule)
  end

  # ========== HELPERS ===========

  def changeset_error_to_string(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
    |> Enum.reduce("", fn {k, v}, acc ->
      joined_errors = Enum.join(v, "; ")
      "#{acc}#{k}: #{joined_errors}, "
    end)
  end
end
