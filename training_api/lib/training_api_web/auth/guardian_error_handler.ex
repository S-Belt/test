defmodule TrainingApiWeb.Auth.GuardianErrorHandler do
  import Plug.Conn

#  def auth_error(conn, {type, reason, value}) do
#    body = Jason.encode!(%{error: reason})
##    conn
##    |> put_status(:unauthorized)
##    |> json(%{error: "Unauthorized"})
##    |> halt()
#  end

  def auth_error(conn, {type, _reason}, opts) do
    body = Jason.encode!(%{error: to_string(type)})
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, body)
  end
end