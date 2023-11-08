defmodule TrainingApi.ClockingFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TrainingApi.Clocking` context.
  """

  @doc """
  Generate a clock.
  """
  def clock_fixture(attrs \\ %{}) do
    {:ok, clock} =
      attrs
      |> Enum.into(%{
        datetime: ~N[2023-10-24 14:59:00],
        status: true
      })
      |> TrainingApi.Clocking.create_clock()

    clock
  end

  @doc """
  Generate a clock.
  """
  def clock_fixture(attrs \\ %{}) do
    {:ok, clock} =
      attrs
      |> Enum.into(%{
        status: true,
        time: ~U[2023-10-25 14:23:00Z]
      })
      |> TrainingApi.Clocking.create_clock()

    clock
  end
end
