defmodule HerenowWeb.Controllers.Client.RequestPasswordRecoveryTest do
  use HerenowWeb.ConnCase, async: true

  alias Herenow.Fixtures
  alias Herenow.Clients.Storage.Mutator

  @client_attrs Fixtures.client_attrs()

  @valid_attrs %{
    "captcha" => "valid",
    "email" => @client_attrs["email"]
  }

  def client_fixture() do
    {:ok, client} = Mutator.create(@client_attrs)
    client
  end

  describe "request_password_recovery/2" do
    test "missing keys", %{conn: conn} do
      attrs =
        @valid_attrs
        |> Map.delete("captcha")

      conn =
        conn
        |> post(client_path(conn, :request_password_recovery), attrs)

      actual = json_response(conn, 422)

      expected = %{
        "code" => 100,
        "message" => "Validation failed!",
        "errors" => [
          %{
            "code" => 104,
            "field" => "captcha",
            "message" => "can't be blank"
          }
        ]
      }

      assert actual == expected
    end

    test "invalid type of keys", %{conn: conn} do
      attrs =
        @valid_attrs
        |> Map.put("captcha", 9)

      conn =
        conn
        |> post(client_path(conn, :request_password_recovery), attrs)

      actual = json_response(conn, 422)

      expected = %{
        "code" => 100,
        "message" => "Validation failed!",
        "errors" => [
          %{"code" => 102, "field" => "captcha", "message" => "is invalid"}
        ]
      }

      assert actual == expected
    end

    test "invalid captcha", %{conn: conn} do
      attrs =
        @valid_attrs
        |> Map.put("captcha", "invalid")

      conn =
        conn
        |> post(client_path(conn, :request_password_recovery), attrs)

      actual = json_response(conn, 422)

      expected = %{
        "code" => 100,
        "message" => "Validation failed!",
        "errors" => [
          %{"code" => 101, "field" => nil, "message" => "Invalid captcha"}
        ]
      }

      assert actual == expected
    end

    test "email should have less than 255 characters", %{conn: conn} do
      email =
        @valid_attrs
        |> Map.get("email")
        |> String.pad_leading(256, "abc")

      attrs =
        @valid_attrs
        |> Map.put("email", email)

      conn =
        conn
        |> post(client_path(conn, :request_password_recovery), attrs)

      actual = json_response(conn, 422)

      expected = %{
        "code" => 100,
        "message" => "Validation failed!",
        "errors" => [
          %{
            "code" => 103,
            "field" => "email",
            "message" => "should be at most 254 character(s)"
          }
        ]
      }

      assert actual == expected
    end

    test "email should have a @", %{conn: conn} do
      attrs =
        @valid_attrs
        |> Map.put("email", "invalidemail")

      conn =
        conn
        |> post(client_path(conn, :request_password_recovery), attrs)

      actual = json_response(conn, 422)

      expected = %{
        "code" => 100,
        "message" => "Validation failed!",
        "errors" => [
          %{
            "code" => 106,
            "field" => "email",
            "message" => "has invalid format"
          }
        ]
      }

      assert actual == expected
    end

    test "client not registered", %{conn: conn} do
      conn =
        conn
        |> post(client_path(conn, :request_password_recovery), @valid_attrs)

      actual = json_response(conn, 200)
      expected = %{"message" => "Email successfully sended!"}

      assert actual == expected
    end

    test "client registered", %{conn: conn} do
      _client = client_fixture()

      conn =
        conn
        |> post(client_path(conn, :request_password_recovery), @valid_attrs)

      actual = json_response(conn, 200)
      expected = %{"message" => "Email successfully sended!"}

      assert actual == expected
    end
  end
end
