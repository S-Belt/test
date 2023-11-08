defmodule ApiWeb.WorkingTimeController do
  use ApiWeb, :controller

  alias Api.Workfollow
  alias Api.Workfollow.WorkingTime

  action_fallback ApiWeb.FallbackController

  def get_working_times(conn, %{"user_id" => user_id} = params) do
    start_time = Map.get(params, "start")
    end_time = Map.get(params, "end")
    filters = Map.take(params, ["start", "end"])

    working_times =
      if start_time && end_time do
        # Appelons la fonction avec les filtres de date si les paramètres sont présents
        Workfollow.get_working_times(user_id, filters)
      else
        # Appelons la fonction sans filtres de date si les paramètres sont absents
        Workfollow.get_working_times(user_id, %{})
      end

    render(conn, "index.json", working_times: working_times)
  end

  def create(conn, %{"user_id" => user_id} = params) do
    case Workfollow.create_working_time(user_id, params) do
      {:ok, working_time} -> render(conn, :show, working_time: working_time)
      {:error, :user_not_found} -> conn |> put_status(:not_found) |> json(%{error: "User not found"})
      {:error, changeset} -> send_resp(conn, 422, "Error: #{changeset}")
    end
  end

  def get_working_time(conn, %{"user_id" => user_id, "id" => id}) do
    case Workfollow.get_working_time(user_id, id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Working time not found"})
      working_time -> render(conn, :show, working_time: working_time)
    end
  end

  def update(conn, %{"id" => id} = params) do
    case Workfollow.update_working_time(id, params) do
      {:ok, working_time} -> render(conn, :show, working_time: working_time)
      {:error, changeset} -> send_resp(conn, 422, "Error: #{changeset}")
    end
  end

  def delete(conn, %{"id" => id}) do
    case Workfollow.delete_working_time(id) do
      {:ok, _working_time} -> send_resp(conn, 204, "")
      {:error, :not_found} -> send_resp(conn, 404, "Working time not found")
      {:error, changeset} -> send_resp(conn, 422, "Error: #{changeset}")
    end
  end
end