defmodule TimeManager.ApplicationTest do
  use TimeManager.DataCase

  alias TimeManager.Application

  describe "users" do
    alias TimeManager.Application.User

    import TimeManager.ApplicationFixtures

    @invalid_attrs %{email: nil, username: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Application.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Application.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{email: "some email", username: "some username"}

      assert {:ok, %User{} = user} = Application.create_user(valid_attrs)
      assert user.email == "some email"
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Application.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{email: "some updated email", username: "some updated username"}

      assert {:ok, %User{} = user} = Application.update_user(user, update_attrs)
      assert user.email == "some updated email"
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Application.update_user(user, @invalid_attrs)
      assert user == Application.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Application.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Application.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Application.change_user(user)
    end
  end

  describe "clocks" do
    alias TimeManager.Application.Clock

    import TimeManager.ApplicationFixtures

    @invalid_attrs %{status: nil, time: nil}

    test "list_clocks/0 returns all clocks" do
      clock = clock_fixture()
      assert Application.list_clocks() == [clock]
    end

    test "get_clock!/1 returns the clock with given id" do
      clock = clock_fixture()
      assert Application.get_clock!(clock.id) == clock
    end

    test "create_clock/1 with valid data creates a clock" do
      valid_attrs = %{status: true, time: ~N[2022-10-24 07:43:00]}

      assert {:ok, %Clock{} = clock} = Application.create_clock(valid_attrs)
      assert clock.status == true
      assert clock.time == ~N[2022-10-24 07:43:00]
    end

    test "create_clock/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Application.create_clock(@invalid_attrs)
    end

    test "update_clock/2 with valid data updates the clock" do
      clock = clock_fixture()
      update_attrs = %{status: false, time: ~N[2022-10-25 07:43:00]}

      assert {:ok, %Clock{} = clock} = Application.update_clock(clock, update_attrs)
      assert clock.status == false
      assert clock.time == ~N[2022-10-25 07:43:00]
    end

    test "update_clock/2 with invalid data returns error changeset" do
      clock = clock_fixture()
      assert {:error, %Ecto.Changeset{}} = Application.update_clock(clock, @invalid_attrs)
      assert clock == Application.get_clock!(clock.id)
    end

    test "delete_clock/1 deletes the clock" do
      clock = clock_fixture()
      assert {:ok, %Clock{}} = Application.delete_clock(clock)
      assert_raise Ecto.NoResultsError, fn -> Application.get_clock!(clock.id) end
    end

    test "change_clock/1 returns a clock changeset" do
      clock = clock_fixture()
      assert %Ecto.Changeset{} = Application.change_clock(clock)
    end
  end

  describe "working_times" do
    alias TimeManager.Application.WorkingTime

    import TimeManager.ApplicationFixtures

    @invalid_attrs %{end: nil, start: nil}

    test "list_working_times/0 returns all working_times" do
      working_time = working_time_fixture()
      assert Application.list_working_times() == [working_time]
    end

    test "get_working_time!/1 returns the working_time with given id" do
      working_time = working_time_fixture()
      assert Application.get_working_time!(working_time.id) == working_time
    end

    test "create_working_time/1 with valid data creates a working_time" do
      valid_attrs = %{end: ~N[2022-10-24 07:44:00], start: ~N[2022-10-24 07:44:00]}

      assert {:ok, %WorkingTime{} = working_time} = Application.create_working_time(valid_attrs)
      assert working_time.end == ~N[2022-10-24 07:44:00]
      assert working_time.start == ~N[2022-10-24 07:44:00]
    end

    test "create_working_time/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Application.create_working_time(@invalid_attrs)
    end

    test "update_working_time/2 with valid data updates the working_time" do
      working_time = working_time_fixture()
      update_attrs = %{end: ~N[2022-10-25 07:44:00], start: ~N[2022-10-25 07:44:00]}

      assert {:ok, %WorkingTime{} = working_time} = Application.update_working_time(working_time, update_attrs)
      assert working_time.end == ~N[2022-10-25 07:44:00]
      assert working_time.start == ~N[2022-10-25 07:44:00]
    end

    test "update_working_time/2 with invalid data returns error changeset" do
      working_time = working_time_fixture()
      assert {:error, %Ecto.Changeset{}} = Application.update_working_time(working_time, @invalid_attrs)
      assert working_time == Application.get_working_time!(working_time.id)
    end

    test "delete_working_time/1 deletes the working_time" do
      working_time = working_time_fixture()
      assert {:ok, %WorkingTime{}} = Application.delete_working_time(working_time)
      assert_raise Ecto.NoResultsError, fn -> Application.get_working_time!(working_time.id) end
    end

    test "change_working_time/1 returns a working_time changeset" do
      working_time = working_time_fixture()
      assert %Ecto.Changeset{} = Application.change_working_time(working_time)
    end
  end
end
