defmodule TrainingApiWeb.Router do
  use TrainingApiWeb, :router
  use Plug.ErrorHandler

  defp handle_error(conn, %{reason: %Phoenix.Router.NoRouteError{message: message}}) do
    conn
      |> json(%{error: message})
      |> halt()
  end

  defp handle_error(conn, %{reason: %{message: message}}) do
    conn
      |> json(%{error: message})
      |> halt()
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  pipeline :auth do
    plug TrainingApiWeb.Auth.Pipeline
    plug TrainingApiWeb.Auth.SetUser
  end

  scope "/api", TrainingApiWeb do
    pipe_through :api

    post "/users/sign_in", UserController, :sign_in
  end

  scope "/api", TrainingApiWeb do
    pipe_through [:api, :auth]

    resources "/users", UserController, except: [:new, :edit]
    resources "/clocks", ClockController, except: [:new, :edit]
  end
end
