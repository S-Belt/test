defmodule ApiWeb.UserJSON do
  alias Api.Accounts.User
  @doc """
  Renders a list of users.
  """
  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  @doc """
  Renders a single user.
  """
  def show_with_token(%{user: user}) do
    %{data: user_with_token(user)}
  end

  def show(%{user: user}) do
    %{data: data(user)}
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      username: user.username,
      email: user.email,
    }
  end

  defp data(%{user: nil}), do: nil

  def user_with_token(%{user: user, token: token}) do
    %{
      id: user.id,
      username: user.username,
      email: user.email,
      token: token,
      role_id: user.role_id,
      team_id: user.team_id,
    }
  end
end
