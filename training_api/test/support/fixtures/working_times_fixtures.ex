defmodule TrainingApi.WorkingTimesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TrainingApi.WorkingTimes` context.
  """

  @doc """
  Generate a working_time.
  """
  def working_time_fixture(attrs \\ %{}) do
    {:ok, working_time} =
      attrs
      |> Enum.into(%{
        end: "some end",
        start: "some start",
        user: "some user"
      })
      |> TrainingApi.WorkingTimes.create_working_time()

    working_time
  end
end
