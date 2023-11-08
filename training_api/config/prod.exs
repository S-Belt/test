import Config

# Do not print debug messages in production
config :logger, level: :info


# Configure your database
config :training_api, TrainingApi.Repo,
       username: "postgres",
       password: "postgres",
       hostname: "db",
       database: "training_api",
       stacktrace: true,
       show_sensitive_data_on_connection_error: true,
       pool_size: 10



# Runtime production configuration, including reading
# of environment variables, is done on config/runtime.exs.
