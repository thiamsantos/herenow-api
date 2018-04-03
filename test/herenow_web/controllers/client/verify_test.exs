defmodule HerenowWeb.Controllers.Client.VerifyTest do
  use HerenowWeb.ConnCase, async: true

  alias Herenow.Fixtures
  alias Herenow.Clients.Storage.Mutator
  alias Herenow.Core.Token

  @expiration_time Application.get_env(
                     :herenow,
                     :account_activation_expiration_time
                   )
  @secret Application.get_env(:herenow, :account_activation_secret)
  @valid_attrs %{
    "captcha" => "valid",
    "token" => Token.generate(%{"client_id" => 1}, @secret, @expiration_time)
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  def client_fixture do
    attrs = Fixtures.client_attrs()

    {:ok, client} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Mutator.create()

    client
  end

  describe "verify/2" do
    test "renders client when data is valid", %{conn: conn} do
      client = client_fixture()
      token = Token.generate(%{"client_id" => client.id}, @secret, @expiration_time)

      attrs =
        @valid_attrs
        |> Map.put("token", token)

      conn =
        conn
        |> post(client_path(conn, :verify), attrs)

      response = json_response(conn, 200)

      assert is_integer(response["id"])
      assert response["latitude"] == client.latitude
      assert response["longitude"] == client.longitude
      assert response["is_company"] == client.is_company
      assert response["name"] == client.name
      assert response["legal_name"] == client.legal_name
      assert response["segment"] == client.segment
      assert response["state"] == client.state
      assert response["street_address"] == client.street_address
      assert response["postal_code"] == client.postal_code
      assert response["city"] == client.city
      assert response["email"] == client.email
    end

    test "missing keys", %{conn: conn} do
      attrs =
        @valid_attrs
        |> Map.delete("captcha")

      conn =
        conn
        |> post(client_path(conn, :verify), attrs)

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
        |> post(client_path(conn, :verify), attrs)

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
        |> post(client_path(conn, :verify), attrs)

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

    test "invalid token signature", %{conn: conn} do
      attrs =
        @valid_attrs
        |> Map.put("token", "invalidtoken")

      conn =
        conn
        |> post(client_path(conn, :verify), attrs)

      actual = json_response(conn, 422)

      expected = %{
        "code" => 100,
        "message" => "Validation failed!",
        "errors" => [
          %{
            "code" => 108,
            "field" => nil,
            "message" => "Invalid signature"
          }
        ]
      }

      assert actual == expected
    end

    test "expired token", %{conn: conn} do
      current_time = 1

      token = Token.generate(%{"client_id" => 1}, @secret, @expiration_time, current_time)

      attrs =
        @valid_attrs
        |> Map.put("token", token)

      conn =
        conn
        |> post(client_path(conn, :verify), attrs)

      actual = json_response(conn, 422)

      expected = %{
        "code" => 100,
        "message" => "Validation failed!",
        "errors" => [
          %{
            "code" => 109,
            "field" => nil,
            "message" => "Expired token"
          }
        ]
      }

      assert actual == expected
    end

    test "client not registered", %{conn: conn} do
      conn =
        conn
        |> post(client_path(conn, :verify), @valid_attrs)

      actual = json_response(conn, 422)

      expected = %{
        "code" => 100,
        "message" => "Validation failed!",
        "errors" => [
          %{
            "code" => 110,
            "field" => "client_id",
            "message" => "does not exist"
          }
        ]
      }

      assert actual == expected
    end

    test "client cannot be activated twice", %{conn: conn} do
      client = client_fixture()

      token = Token.generate(%{"client_id" => client.id}, @secret, @expiration_time)

      attrs =
        @valid_attrs
        |> Map.put("token", token)

      Mutator.verify(%{client_id: client.id})

      conn =
        conn
        |> post(client_path(conn, :verify), attrs)

      actual = json_response(conn, 422)

      expected = %{
        "code" => 100,
        "message" => "Validation failed!",
        "errors" => [
          %{
            "code" => 107,
            "field" => "client_id",
            "message" => "has already been taken"
          }
        ]
      }

      assert actual == expected
    end
  end
end
