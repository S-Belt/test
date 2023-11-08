defmodule Api.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :username, :string
    field :email, :string
    field :hash_password, :string
    field :role_id, :integer
    belongs_to :team, Api.Accounts.Team, foreign_key: :team_id
    has_many :working_times, Api.Workfollow.WorkingTime, on_delete: :delete_all
    has_many :clocks, Api.Clocking.Clock, on_delete: :delete_all

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :hash_password, :role_id, :team_id])
    |> validate_required([:username, :email, :hash_password, :role_id])
    |> validate_format(:email, ~r/^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/, message: "Invalid email format")
    |> validate_length(:username, min: 3, max: 160)
    |> unique_constraint(:email, message: "This email already exists")
    |> unique_constraint(:username, message: "This username already exists")
    |> hash_password()
  end

  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{hash_password: plain_password}} = changeset) do
    hash = Bcrypt.hash_pwd_salt(plain_password)
    change(changeset, hash_password: hash)
  end
  defp hash_password(changeset), do: changeset
end
