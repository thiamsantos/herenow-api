defmodule PhxdemoWeb.AuthControllerTest do
  use PhxdemoWeb.ConnCase

  @invalid_credentials %{password: "hey", user: "root"}
  @credentials %{password: "toor", user: "root"}

  describe "auth" do
    test "create token", %{conn: conn} do
      conn = post(conn, auth_path(conn, :create), @credentials)

      assert %{"token" => _token} = json_response(conn, 200)
    end

    test "invalid credentials", %{conn: conn} do
      conn = post(conn, auth_path(conn, :create), @invalid_credentials)

      assert %{"message" => _message} = json_response(conn, 401)
    end
  end
end
