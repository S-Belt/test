defmodule TrainingApiWeb.DefaultController do
  use TrainingApiWeb, :controller

  def index(conn, _params) do
    text conn, "Welcome to Phoenix! - #{Mix.env()}"
  end

end
