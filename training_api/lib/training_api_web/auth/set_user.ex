defmodule TrainingApiWeb.Auth.SetUser do
  import Plug.Conn
  alias TrainingApi.Auth.ErrorResponse
  alias TrainingApi.Accounts

  def init(_opts) do
  end

  def call(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
    else
      user_id = get_session(conn, :current_user)

      if user_id == nil, do: raise ErrorResponse.Unauthorized

      user = Accounts.get_user!(user_id)
      cond do
        user_id && user ->
          assign(conn, :current_user, user)
        true -> assign(conn, :current_user, nil)
      end
    end
  end
end