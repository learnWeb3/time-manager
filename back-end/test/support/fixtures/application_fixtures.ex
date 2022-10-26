defmodule TimeManager.ApplicationFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManager.Application` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "some email",
        username: "some username"
      })
      |> TimeManager.Application.create_user()

    user
  end

  @doc """
  Generate a clock.
  """
  def clock_fixture(attrs \\ %{}) do
    {:ok, clock} =
      attrs
      |> Enum.into(%{
        status: true,
        time: ~N[2022-10-24 07:43:00]
      })
      |> TimeManager.Application.create_clock()

    clock
  end

  @doc """
  Generate a working_time.
  """
  def working_time_fixture(attrs \\ %{}) do
    {:ok, working_time} =
      attrs
      |> Enum.into(%{
        end: ~N[2022-10-24 07:44:00],
        start: ~N[2022-10-24 07:44:00]
      })
      |> TimeManager.Application.create_working_time()

    working_time
  end
end
