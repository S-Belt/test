defmodule Api.WorkfollowFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Api.Workfollow` context.
  """

  @doc """
  Generate a working_time.
  """
  def working_time_fixture(attrs \\ %{}) do
    {:ok, working_time} =
      attrs
      |> Enum.into(%{
        end: ~U[2023-11-05 15:25:00Z],
        start: ~U[2023-11-05 15:25:00Z]
      })
      |> Api.Workfollow.create_working_time()

    working_time
  end

  @doc """
  Generate a working_time.
  """
  def working_time_fixture(attrs \\ %{}) do
    {:ok, working_time} =
      attrs
      |> Enum.into(%{
        end: ~U[2023-11-05 20:50:00Z],
        start: ~U[2023-11-05 20:50:00Z]
      })
      |> Api.Workfollow.create_working_time()

    working_time
  end
end
