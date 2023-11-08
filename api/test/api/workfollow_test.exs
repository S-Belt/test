defmodule Api.WorkfollowTest do
  use Api.DataCase

  alias Api.Workfollow

  describe "working_times" do
    alias Api.Workfollow.WorkingTime

    import Api.WorkfollowFixtures

    @invalid_attrs %{start: nil, end: nil}

    test "list_working_times/0 returns all working_times" do
      working_time = working_time_fixture()
      assert Workfollow.list_working_times() == [working_time]
    end

    test "get_working_time!/1 returns the working_time with given id" do
      working_time = working_time_fixture()
      assert Workfollow.get_working_time!(working_time.id) == working_time
    end

    test "create_working_time/1 with valid data creates a working_time" do
      valid_attrs = %{start: ~U[2023-11-05 15:25:00Z], end: ~U[2023-11-05 15:25:00Z]}

      assert {:ok, %WorkingTime{} = working_time} = Workfollow.create_working_time(valid_attrs)
      assert working_time.start == ~U[2023-11-05 15:25:00Z]
      assert working_time.end == ~U[2023-11-05 15:25:00Z]
    end

    test "create_working_time/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Workfollow.create_working_time(@invalid_attrs)
    end

    test "update_working_time/2 with valid data updates the working_time" do
      working_time = working_time_fixture()
      update_attrs = %{start: ~U[2023-11-06 15:25:00Z], end: ~U[2023-11-06 15:25:00Z]}

      assert {:ok, %WorkingTime{} = working_time} = Workfollow.update_working_time(working_time, update_attrs)
      assert working_time.start == ~U[2023-11-06 15:25:00Z]
      assert working_time.end == ~U[2023-11-06 15:25:00Z]
    end

    test "update_working_time/2 with invalid data returns error changeset" do
      working_time = working_time_fixture()
      assert {:error, %Ecto.Changeset{}} = Workfollow.update_working_time(working_time, @invalid_attrs)
      assert working_time == Workfollow.get_working_time!(working_time.id)
    end

    test "delete_working_time/1 deletes the working_time" do
      working_time = working_time_fixture()
      assert {:ok, %WorkingTime{}} = Workfollow.delete_working_time(working_time)
      assert_raise Ecto.NoResultsError, fn -> Workfollow.get_working_time!(working_time.id) end
    end

    test "change_working_time/1 returns a working_time changeset" do
      working_time = working_time_fixture()
      assert %Ecto.Changeset{} = Workfollow.change_working_time(working_time)
    end
  end

  describe "working_times" do
    alias Api.Workfollow.WorkingTime

    import Api.WorkfollowFixtures

    @invalid_attrs %{start: nil, end: nil}

    test "list_working_times/0 returns all working_times" do
      working_time = working_time_fixture()
      assert Workfollow.list_working_times() == [working_time]
    end

    test "get_working_time!/1 returns the working_time with given id" do
      working_time = working_time_fixture()
      assert Workfollow.get_working_time!(working_time.id) == working_time
    end

    test "create_working_time/1 with valid data creates a working_time" do
      valid_attrs = %{start: ~U[2023-11-05 20:50:00Z], end: ~U[2023-11-05 20:50:00Z]}

      assert {:ok, %WorkingTime{} = working_time} = Workfollow.create_working_time(valid_attrs)
      assert working_time.start == ~U[2023-11-05 20:50:00Z]
      assert working_time.end == ~U[2023-11-05 20:50:00Z]
    end

    test "create_working_time/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Workfollow.create_working_time(@invalid_attrs)
    end

    test "update_working_time/2 with valid data updates the working_time" do
      working_time = working_time_fixture()
      update_attrs = %{start: ~U[2023-11-06 20:50:00Z], end: ~U[2023-11-06 20:50:00Z]}

      assert {:ok, %WorkingTime{} = working_time} = Workfollow.update_working_time(working_time, update_attrs)
      assert working_time.start == ~U[2023-11-06 20:50:00Z]
      assert working_time.end == ~U[2023-11-06 20:50:00Z]
    end

    test "update_working_time/2 with invalid data returns error changeset" do
      working_time = working_time_fixture()
      assert {:error, %Ecto.Changeset{}} = Workfollow.update_working_time(working_time, @invalid_attrs)
      assert working_time == Workfollow.get_working_time!(working_time.id)
    end

    test "delete_working_time/1 deletes the working_time" do
      working_time = working_time_fixture()
      assert {:ok, %WorkingTime{}} = Workfollow.delete_working_time(working_time)
      assert_raise Ecto.NoResultsError, fn -> Workfollow.get_working_time!(working_time.id) end
    end

    test "change_working_time/1 returns a working_time changeset" do
      working_time = working_time_fixture()
      assert %Ecto.Changeset{} = Workfollow.change_working_time(working_time)
    end
  end
end
