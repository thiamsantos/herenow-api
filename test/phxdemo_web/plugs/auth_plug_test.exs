defmodule HereNowWeb.AuthPlugTest do
  use HereNowWeb.ConnCase

  alias HereNowWeb.AuthPlug

  describe "auth plug" do
    test "should return 401 if token not found", %{conn: conn} do
      conn = conn
      |> AuthPlug.call(%{})

      assert conn.status == 401
    end

    test "should return 401 if token is invalid", %{conn: conn} do
      conn = conn
      |> put_req_header("authorization", "Some token")
      |> AuthPlug.call(%{})

      assert conn.status == 401
    end

    test "request passes when token is found", %{conn: conn} do
      conn = conn
      |> authenticate_conn()
      |> AuthPlug.call(%{})

      assert conn.status != 401
    end
  end
end
