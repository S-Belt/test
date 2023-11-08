defmodule Api.Workfollow do
  @moduledoc """
  The Workfollow context.
  """

  import Ecto.Query, warn: false
  alias Api.Repo

  alias Api.Workfollow.WorkingTime

  def get_working_times(user_id, %{start: start_time, end: end_time} = _params) do
    query = from wt in WorkingTime,
                 where: wt.user_id == ^user_id,
                 where: wt.start >= ^start_time,
                 where: wt.end <= ^end_time,
                 order_by: [asc: wt.start]

    Repo.all(query)
  end

  def get_working_times(user_id, _params) do
    Repo.all(from wt in WorkingTime, where: wt.user_id == ^user_id, order_by: [asc: wt.start])
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
  def get_working_time(user_id, id) do
    Repo.get_by(WorkingTime, id: id, user_id: user_id)
  end

  def create_working_time(user_id, attrs) do
    try do
      # Vérifie si l'utilisateur existe
      _user = Api.Accounts.get_user!(user_id)
      # Si l'utilisateur existe, continue la création du WorkingTime
      attrs = Map.put(attrs, "user_id", user_id)
      IO.inspect(attrs)
      %WorkingTime{}
      |> WorkingTime.changeset(attrs)
      |> Repo.insert()
    rescue
      # Capturer l'exception si l'utilisateur n'existe pas
      Ecto.NoResultsError ->
        {:error, :user_not_found}
    end
  end

  def update_working_time(id, attrs) do
    Repo.get(WorkingTime, id)
    |> WorkingTime.changeset(attrs)
    |> Repo.update()
  end

  def delete_working_time(id) do
    working_time = Repo.get!(WorkingTime, id)
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
