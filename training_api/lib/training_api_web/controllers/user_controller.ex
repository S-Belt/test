defmodule TrainingApiWeb.UserController do
  use TrainingApiWeb, :controller

  alias TrainingApi.Accounts
  alias TrainingApi.Accounts.User
  alias TrainingApiWeb.{Auth.Guardian, Auth.ErrorResponse}
  alias HTTPoison

  plug :is_authorized_user when action in [:create, :delete, :update]

  action_fallback TrainingApiWeb.FallbackController


    # Use the renamed get_user function which matches {:ok, user} or {:error, reason}
    defp is_authorized_user(conn, _opts) do
      # User from session
      {:ok, sessionUser} = conn.assigns.current_user

      # User from params
      id = conn.params["id"]
      {:ok, user} = Accounts.get_user!(id)

      IO.inspect(user)
      IO.inspect(sessionUser)
      
      if sessionUser.id == user.id do
        conn
      else
        raise ErrorResponse.Forbidden
      end
    end

  def index(conn, params) do
    case Map.keys(params) do
      ["email", "username"] -> get_user(conn, params, :get_user_by_email_and_username)
      ["email"]             -> get_user(conn, params, :get_user_by_email)
      ["username"]          -> get_user(conn, params, :get_user_by_username)
      []                    -> get_all_users(conn)
      _                     -> send_bad_request(conn)
    end
  end

  defp get_user(conn, %{"email" => email, "username" => username}, :get_user_by_email_and_username) do
    respond_with_user(conn, Accounts.get_user_by_email_and_username(email, username))
  end
  defp get_user(conn, %{"email" => email}, :get_user_by_email) do
    respond_with_user(conn, Accounts.get_user_by_email(email))
  end
  defp get_user(conn, %{"username" => username}, :get_user_by_username) do
    respond_with_user(conn, Accounts.get_user_by_username(username))
  end

  defp get_all_users(conn) do
    users = Accounts.list_users()
    render(conn, :index, users: users)
  end

  defp respond_with_user(conn, nil), do: conn |> put_status(:not_found) |> json(%{error: "User not found"})
  defp respond_with_user(conn, user), do: render(conn, :show, user: user)

  defp send_bad_request(conn), do: conn |> put_status(:bad_request) |> json(%{error: "Invalid parameters"})

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params),
          {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(:created)
      |> render(:user_with_token, user: user, token: token)
    end
  end

#  def sign_in(conn, %{"email" => email, "password" -> password}) do
#      case Accounts.get_user_by_email(email) do
#      nil ->
#        conn
#        |> put_status(:not_found)
#        |> json(%{error: "User not found"})
#      user ->
#        case Accounts.authenticate_user(user, password) do
#          {:ok, user} ->
#            {:ok, token, _claims} = Guardian.encode_and_sign(user)
#            conn
#            |> put_status(:ok)
#            |> render(:user_with_token, user: user, token: token)
#          {:error, :unauthorized} ->
#            conn
#            |> put_status(:unauthorized)
#            |> json(%{error: "Invalid password"})
#        end
#    end end

  def sign_in(conn, %{"email" => email, "password" => password}) do
    case Guardian.authenticate(email, password) do
      {:ok, user, token} ->
        conn
        |> Plug.Conn.put_session(:current_user, user.id)
        |> put_status(:ok)
        |> render("user_with_token.json", user: user, token: token)
      {:error, :unauthorized} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid email or password"})
    end
  end

  def sign_in(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> json(%{error: "Missing email or password"})
  end



  def show(conn, %{"id" => id}) do
    IO.inspect(conn.assigns)
    case Accounts.get_user!(id) do
      {:ok, user} ->
        render(conn, "show.json", user: user)
      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "User not found"})
      {:error, :invalid_uuid} ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "Invalid UUID format"})
    end
  end

  def update(conn, %{"user" => user_params}) do
    user = Accounts.get_user!(user_params["id"])

    user = Accounts.preload_user_clocks(user)
    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    try do
      user = Accounts.get_user!(id)
      with {:ok, %User{}} <- Accounts.delete_user(user) do
        send_resp(conn, :no_content, "")
      else
        {:error, reason} -> handle_delete_error(conn, reason)
      end
    rescue
      Ecto.NoResultsError ->
        conn
        |> put_status(:not_found)
        |> json(%{
          status: "error",
          error: "User not found"
        })

      # Vous pouvez ajouter d'autres clauses de gestion d'erreur ici si nécessaire
      # par exemple :
      # %SomeSpecificError{message: msg} ->
      #   conn
      #   |> put_status(:bad_request)
      #   |> json(%{status: "error", error: msg})
    end
  end

  defp handle_delete_error(conn, reason) do
    # Ici, vous pouvez gérer les différentes raisons pour lesquelles la suppression peut échouer
    conn
    |> put_status(:internal_server_error)
    |> json(%{
      status: "error",
      error: "Failed to delete user",
      reason: to_string(reason)
    })
  end
end