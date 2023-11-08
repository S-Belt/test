defmodule ApiWeb.ClockController do
  use ApiWeb, :controller

  alias Api.Clocking
  alias Api.Clocking.Clock

  action_fallback ApiWeb.FallbackController

  def index(conn, _params) do
    clocks = Clocking.list_clocks()
    render(conn, :index, clocks: clocks)
  end

  def create(conn, %{"clock" => clock_params}) do
    clock_params = Map.put(clock_params, "user_id", conn.params["user_id"])
    with {:ok, %Clock{} = clock} <- Clocking.create_clock(clock_params) do
      conn
      |> put_status(:created)
      |> render(:show, clock: clock)
    end
  end

  def show(conn, %{"id" => id}) do
    clock = Clocking.get_clock!(id)
    render(conn, :show, clock: clock)
  end

  def update(conn, %{"id" => id, "clock" => clock_params}) do
    clock = Clocking.get_clock!(id)
    with {:ok, %Clock{} = clock} <- Clocking.update_clock(clock, clock_params) do
      render(conn, :show, clock: clock)
    end
  end

  def delete(conn, %{"id" => id}) do
    clock = Clocking.get_clock!(id)

    with {:ok, %Clock{}} <- Clocking.delete_clock(clock) do
      send_resp(conn, :no_content, "")
    end
  end

  def get_clocks(conn, %{"user_id" => user_id}) do
    clocks = Clocking.get_clocks_by_user_id(user_id)
    render(conn, :index, clocks: clocks)
  end
end
