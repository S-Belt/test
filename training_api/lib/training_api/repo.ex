defmodule TrainingApi.Repo do
  use Ecto.Repo,
    otp_app: :training_api,
    adapter: Ecto.Adapters.Postgres
end
