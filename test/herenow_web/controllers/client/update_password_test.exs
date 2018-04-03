defmodule HerenowWeb.Controllers.Client.UpdatePasswordTest do
  use HerenowWeb.ConnCase, async: true

  alias Herenow.Fixtures
  alias Herenow.Clients.Storage.{Mutator, Loader}
  alias Herenow.Clients.PasswordHash

  @client_attrs Fixtures.client_attrs()

  @valid_attrs %{
    "current_password" => @client_attrs["password"],
    "password" => "new password"
  }

  setup %{conn: conn} do
    {:ok, client} = Mutator.create(@client_attrs)
    {:ok, _verified_client} = Mutator.verify(%{"client_id" => client.id})

    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> authenticate_conn(%{email: @client_attrs["email"], password: @client_attrs["password"]})

    {:ok, conn: conn}
  end

  describe "update_password/2" do
    test "missing keys", %{conn: conn} do
      attrs =
        @valid_attrs
        |> Map.delete("password")

      conn =
        conn
        |> put(client_path(conn, :update_password), attrs)

      actual = json_response(conn, 422)

      expected = %{
        "code" => 100,
        "message" => "Validation failed!",
        "errors" => [
          %{
            "code" => 104,
            "field" => "password",
            "message" => "can't be blank"
          }
        ]
      }

      assert actual == expected
    end

    test "invalid type of keys", %{conn: conn} do
      attrs =
        @valid_attrs
        |> Map.put("password", 9)

      conn =
        conn
        |> put(client_path(conn, :update_password), attrs)

      actual = json_response(conn, 422)

      expected = %{
        "code" => 100,
        "message" => "Validation failed!",
        "errors" => [
          %{"code" => 102, "field" => "password", "message" => "is invalid"}
        ]
      }

      assert actual == expected
    end

    test "weak password", %{conn: conn} do
      attrs =
        @valid_attrs
        |> Map.put("password", "weak")

      conn =
        conn
        |> put(client_path(conn, :update_password), attrs)

      actual = json_response(conn, 422)

      expected = %{
        "code" => 100,
        "message" => "Validation failed!",
        "errors" => [
          %{
            "code" => 103,
            "field" => "password",
            "message" => "should be at least 8 character(s)"
          }
        ]
      }

      assert actual == expected
    end

    test "invalid current password", %{conn: conn} do
      attrs =
        @valid_attrs
        |> Map.put("current_password", "invalid password")

      conn =
        conn
        |> put(client_path(conn, :update_password), attrs)

      actual = json_response(conn, 401)

      expected = %{
        "code" => 300,
        "errors" => [%{"code" => 303, "message" => "Invalid password"}],
        "message" => "Authorization failed!"
      }

      assert actual == expected
    end

    test "change the password", %{conn: conn} do
      put(conn, client_path(conn, :update_password), @valid_attrs)
      client = Loader.get_one_by_email(@client_attrs["email"])

      persisted_client = Loader.get!(client.id)
      assert {:ok} == PasswordHash.valid?(@valid_attrs["password"], persisted_client.password)

      assert {:error, :invalid_password} ==
               PasswordHash.valid?(@client_attrs["password"], persisted_client.password)
    end
  end
end
