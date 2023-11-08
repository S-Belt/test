defmodule TrainingApiWeb.Auth.Pipeline do
  use Guardian.Plug.Pipeline, otp_app: :training_api,
  module: TrainingApiWeb.Auth.Guardian,
  error_handler: TrainingApiWeb.Auth.GuardianErrorHandler

  plug Guardian.Plug.VerifySession
  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end