# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config
#import Dotenv

# Read environment variables from .env file
config :dotenv,
  path: Path.expand("../.env", __DIR__)


config :training_api,
  ecto_repos: [TrainingApi.Repo],
  generators: [timestamp_type: :utc_datetime, binary_id: true]

# Configures the endpoint
config :training_api, TrainingApiWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Phoenix.Endpoint.Cowboy2Adapter,
  render_errors: [
    formats: [json: TrainingApiWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: TrainingApi.PubSub,
  live_view: [signing_salt: "pWFtNWEl"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configures Guardian
config :training_api, TrainingApiWeb.Auth.Guardian,
  issuer: "training_api",
  secret_key: "E8QRSZRPMWg0nvzL32fSNenwc7rY25vbmBzy1spEIXVGygjH6zMMMWoM7L+5jXN3"

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
