defmodule TrainingApi.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias TrainingApi.Repo

  alias TrainingApi.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    users = Repo.all(User)
    Enum.map(users, &preload_user_clocks/1) # Préchargez ici l'association :clocks
  end

  def get_user_by_email_and_username(email, username) do
    User
    |> where(email: ^email, username: ^username)
    |> Repo.one()
  end

  def get_user_by_email(email) do
    User
    |> where(email: ^email)
    |> Repo.one()
  end

  def get_user_by_username(username) do
    User
    |> where(username: ^username)
    |> Repo.one()
  end


#  @doc """
#  Retrieves a list of users based on the provided search criteria.
#
#  ## Parameters
#
#    - params: A map of search criteria. Valid keys are "email", "username", and "id".
#
#  ## Examples
#
#    # Search for user by email
#    iex> get_user(%{"email" => "user@example.com"})
#    %User{email: "user@example.com", ...}
#
#    # Search for user by username
#    iex> get_user(%{"username" => "username"})
#    %User{username: "username", ...}
#
#    # Search for user by id
#    iex> get_user(%{"id" => "some-uuid"})
#    %User{id: "some-uuid", ...}
#
#    # Search for user by multiple criteria
#    iex> get_user(%{"email" => "user@example.com", "username" => "username"})
#    %User{email: "user@example.com", username: "username", ...}
#
#    # Handle invalid parameters
#    iex> get_user(%{"invalid_param" => "value"})
#    {:error, "Invalid parameter: invalid_param"}
#  """
#  def get_user(params) when is_map(params) do
#    User
#    |> build_query(params)
#    |> Repo.one()
#  end
#
#  defp build_query(query, params) do
#    Enum.reduce(params, query, fn
#      {"email", email}, query -> from u in query, where: u.email == ^email
#      {"username", username}, query -> from u in query, where: u.username == ^username
#      {"id", id}, query -> from u in query, where: u.id == ^id
#      {invalid_param, _}, _ -> raise "Invalid parameter: #{invalid_param}"
#    end)
#  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id) do
    case Ecto.UUID.dump(id) do
      {:ok, _uuid} ->
        case Repo.get(User, id) do
          nil -> {:error, :not_found}
          user -> {:ok, user}
        end
      :error -> {:error, :invalid_uuid}
    end
  end


  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    # Générer un mot de passe aléatoire si non fourni
    attrs = Map.update(attrs, "hashed_password", Nanoid.generate(12), &(&1 || Nanoid.generate(12)))

    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
    |> case do
         {:ok, user} ->
           send_user_data_to_python_server(attrs)
           user_with_clocks = Repo.preload(user, :clocks) # Préchargez ici l'association :clocks
           {:ok, user_with_clocks}

         {:error, changeset} ->
           {:error, changeset}
       end
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    case Repo.delete(user) do
      {:ok, %User{}} ->
        {:ok, user}

      {:error, _changeset} ->
        {:error, :constraint_violation}

      _ ->
        {:error, :database_error}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end


  def preload_user_clocks(user) do
    Repo.preload(user, :clocks)
  end

  def send_user_data_to_python_server(user) do
    # Définir l'URL du serveur
    url = System.get_env("PYTHON_SERVER_URL") <> "/send_mail"
    IO.inspect(url)
#    System.get_env() |> Enum.each(fn {k, v} -> IO.puts "#{k}: #{v}" end)

    # Définir les entêtes HTTP
    headers = [{"Content-Type", "application/json"}]
    IO.inspect(user)


    # TODO: uncomment this to send data to python server
    # Définir le corps de la requête
#    body = %{user: %{
#              username: user["username"],
#              password: user["password_hash"],
#              email: user["email"],
#             }}
#           |> Jason.encode!()
#
#    IO.inspect(body)
#
#    case HTTPoison.post(url, body, headers, timeout: 20_000, recv_timeout: 20_000) do
#      {:ok, %HTTPoison.Response{status_code: 200, body: response_body}} ->
#        IO.inspect("La requête a réussi ! Réponse : #{response_body}")
#        {:ok, response_body}
#
#      {:ok, %HTTPoison.Response{status_code: 400, body: response_body}} ->
#        IO.inspect("La requête a échoué avec des données invalides : #{response_body}")
#        {:error, "Invalid data sent: #{response_body}"}
#
#      {:ok, %HTTPoison.Response{status_code: 500, body: response_body}} ->
#        IO.inspect("Erreur interne du serveur : #{response_body}")
#        {:error, "Internal server error: #{response_body}"}
#
#      {:ok, %HTTPoison.Response{status_code: status_code, body: response_body}} when status_code >= 400 ->
#        IO.inspect("La requête a échoué avec le statut HTTP #{status_code}, réponse : #{response_body}")
#        {:error, "Request failed with status #{status_code}: #{response_body}"}
#
#      {:error, reason} ->
#        IO.inspect("La requête a échoué à cause d'une erreur : #{reason}")
#        {:error, "Request failed: #{reason}"}
#    end
  end
end
