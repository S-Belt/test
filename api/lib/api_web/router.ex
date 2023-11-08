defmodule ApiWeb.Router do
  use ApiWeb, :router
  use Plug.ErrorHandler

  defp handle_errors(conn, %{reason: %Phoenix.Router.NoRouteError{message: message}}) do
    conn
      |> json(%{error: message})
      |> halt()
  end

  defp handle_errors(conn, %{reason: %{message: message}}) do
    conn
      |> json(%{error: message})
      |> halt()
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug ApiWeb.Auth.Pipeline
  end

  scope "/api", ApiWeb do
    pipe_through :api

    # Users
    resources "/users", UserController, except: [:new, :edit]
    post "/users/sign_in", UserController, :sign_in

    # Teams
    resources "/teams", TeamController, except: [:new, :edit]




  end

  # Protect routes with Guardian
  scope "/api", ApiWeb do
    pipe_through [:api, :auth]

    # Working times
    get "/workingtimes/:user_id", WorkingTimeController, :get_working_times
    get "/workingtimes/:user_id/:id", WorkingTimeController, :get_working_time
    post "/workingtimes/:user_id", WorkingTimeController, :create
    put "/workingtimes/:id", WorkingTimeController, :update
    delete "/workingtimes/:id", WorkingTimeController, :delete

    # Clocking
    get "/clocks/:user_id", ClockController, :get_clocks
    get "/clocks", ClockController, :index
    post "/clocks/:user_id", ClockController, :create
  end
end
