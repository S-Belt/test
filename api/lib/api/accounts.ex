defmodule Api.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Api.Repo

  alias Api.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Get a single user by email.

  Returns `nil` if the User does not exist.

  ## Examples

      iex> get_user_by_email("exemple@gmail.com")
      %User{}

      iex> get_user_by_email("notfound@gmail.com")
      nil
  """
  def get_user_by_email(email) do
    User
      |> where([u], u.email == ^email)
      |> Repo.one()
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
    attrs = Map.update(attrs, "hash_password", Nanoid.generate(12), &(&1 || Nanoid.generate(12)))
    IO.inspect(attrs)
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
    |> case do
         {:ok, user} ->
           send_user_data_to_python_server(attrs)
#           user_with_clocks = Repo.preload(user, :clocks) # Préchargez ici l'association :clocks
           {:ok, user}

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
    Repo.delete(user)
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

  alias Api.Accounts.Team

  @doc """
  Returns the list of teams.

  ## Examples

      iex> list_teams()
      [%Team{}, ...]

  """
  def list_teams do
    Repo.all(Team)
  end

  @doc """
  Gets a single team.

  Raises `Ecto.NoResultsError` if the Team does not exist.

  ## Examples

      iex> get_team!(123)
      %Team{}

      iex> get_team!(456)
      ** (Ecto.NoResultsError)

  """
  def get_team!(id), do: Repo.get!(Team, id)

  @doc """
  Creates a team.

  ## Examples

      iex> create_team(%{field: value})
      {:ok, %Team{}}

      iex> create_team(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_team(attrs \\ %{}) do
    %Team{}
    |> Team.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a team.

  ## Examples

      iex> update_team(team, %{field: new_value})
      {:ok, %Team{}}

      iex> update_team(team, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_team(%Team{} = team, attrs) do
    team
    |> Team.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a team.

  ## Examples

      iex> delete_team(team)
      {:ok, %Team{}}

      iex> delete_team(team)
      {:error, %Ecto.Changeset{}}

  """
  def delete_team(%Team{} = team) do
    Repo.delete(team)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking team changes.

  ## Examples

      iex> change_team(team)
      %Ecto.Changeset{data: %Team{}}

  """
  def change_team(%Team{} = team, attrs \\ %{}) do
    Team.changeset(team, attrs)
  end

  defp send_user_data_to_python_server(user) do
    # Définir l'URL du serveur
    url = System.get_env("PYTHON_SERVER_URL") <> "/send_mail"
    IO.inspect(url)
#    System.get_env() |> Enum.each(fn {k, v} -> IO.puts "#{k}: #{v}" end)

    # Définir les entêtes HTTP
    headers = [{"Content-Type", "application/json"}]
    IO.inspect(user)


    # Définir le corps de la requête
        body = %{user: %{
                  username: user["username"],
                  password: user["hash_password"],
                  email: user["email"],
                 }}
               |> Jason.encode!()
        IO.inspect(body)

        case HTTPoison.post(url, body, headers, timeout: 20_000, recv_timeout: 20_000) do
          {:ok, %HTTPoison.Response{status_code: 200, body: response_body}} ->
            IO.inspect("La requête a réussi ! Réponse : #{response_body}")
            {:ok, response_body}

          {:ok, %HTTPoison.Response{status_code: 400, body: response_body}} ->
            IO.inspect("La requête a échoué avec des données invalides : #{response_body}")
            {:error, "Invalid data sent: #{response_body}"}

          {:ok, %HTTPoison.Response{status_code: 500, body: response_body}} ->
            IO.inspect("Erreur interne du serveur : #{response_body}")
            {:error, "Internal server error: #{response_body}"}

          {:ok, %HTTPoison.Response{status_code: status_code, body: response_body}} when status_code >= 400 ->
            IO.inspect("La requête a échoué avec le statut HTTP #{status_code}, réponse : #{response_body}")
            {:error, "Request failed with status #{status_code}: #{response_body}"}

          {:error, reason} ->
            IO.inspect("La requête a échoué à cause d'une erreur : #{reason}")
            {:error, "Request failed: #{reason}"}
        end
  end
end
