defmodule ApiWeb.UserControllerTest do
  use ApiWeb.ConnCase

  import Api.AccountsFixtures

  alias Api.Accounts.User

  @create_attrs %{
    username: "some username",
    email: "some email",
    hash_password: "some hash_password",
    role_id: "7488a646-e31f-11e4-aace-600308960662",
    team_id: "7488a646-e31f-11e4-aace-600308960662"
  }
  @update_attrs %{
    username: "some updated username",
    email: "some updated email",
    hash_password: "some updated hash_password",
    role_id: "7488a646-e31f-11e4-aace-600308960668",
    team_id: "7488a646-e31f-11e4-aace-600308960668"
  }
  @invalid_attrs %{username: nil, email: nil, hash_password: nil, role_id: nil, team_id: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get(conn, ~p"/api/users")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/users/#{id}")

      assert %{
               "id" => ^id,
               "email" => "some email",
               "hash_password" => "some hash_password",
               "role_id" => "7488a646-e31f-11e4-aace-600308960662",
               "team_id" => "7488a646-e31f-11e4-aace-600308960662",
               "username" => "some username"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put(conn, ~p"/api/users/#{user}", user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/users/#{id}")

      assert %{
               "id" => ^id,
               "email" => "some updated email",
               "hash_password" => "some updated hash_password",
               "role_id" => "7488a646-e31f-11e4-aace-600308960668",
               "team_id" => "7488a646-e31f-11e4-aace-600308960668",
               "username" => "some updated username"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, ~p"/api/users/#{user}", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, ~p"/api/users/#{user}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/users/#{user}")
      end
    end
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end
end
