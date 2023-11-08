# TrainingApi

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).
# tjytjtyfjc

## Configure guardian :
1. Generate a secret key : 
    ```bash
    mix phx.gen.secret
    ```
2. Add the secret in the `config.exs` file 
```
# Configures Guardian
config :name_of_your_app, TrainingApiWeb.Auth.Guardian,
  issuer: "name_of_your_app",
  secret_key: "your_generated_secret_key",
```
 

## Add database

    ```bash
    mix ecto.create
    mix ecto.migrate
    ```

## 

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
