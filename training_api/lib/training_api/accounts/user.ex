defmodule TrainingApi.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :username, :string
    field :email, :string
    field :hashed_password, :string, virtual: true
    field :password_hash, :string
    has_many :clocks, TrainingApi.Clocking.Clock

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :hashed_password])
    |> validate_required([:username, :email, :hashed_password])
    |> validate_format(:email, ~r/^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/, message: "Invalid email format")
    |> validate_length(:username, min: 3, max: 160)
    |> unique_constraint(:email, message: "This email already exists")
    |> unique_constraint(:username, message: "This username already exists")
    |> hash_password()
  end

  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{hashed_password: plain_password}} = changeset) do
    hash = Bcrypt.hash_pwd_salt(plain_password)
    change(changeset, password_hash: hash)
  end
  defp hash_password(changeset), do: changeset
end
