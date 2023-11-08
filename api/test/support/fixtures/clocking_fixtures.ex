defmodule Api.ClockingFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Api.Clocking` context.
  """

  @doc """
  Generate a clock.
  """
  def clock_fixture(attrs \\ %{}) do
    {:ok, clock} =
      attrs
      |> Enum.into(%{
        status: true,
        time: ~U[2023-11-05 15:24:00Z]
      })
      |> Api.Clocking.create_clock()

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
        time: ~U[2023-11-05 20:11:00Z]
      })
      |> Api.Clocking.create_clock()

    clock
  end
end
