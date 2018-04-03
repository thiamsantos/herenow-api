defmodule HerenowWeb.Controllers.AuthTest do
  use HerenowWeb.ConnCase, async: true

  alias Faker.{Name, Address, Commerce, Internet, Company}
  alias Herenow.Clients.Storage.{Mutator}

  @client_attrs %{
    "latitude" => Address.latitude(),
    "longitude" => Address.longitude(),
    "is_company" => true,
    "name" => Name.name(),
    "password" => "some password",
    "legal_name" => Company.name(),
    "segment" => Commerce.department(),
    "state" => Address.state(),
    "street_address" => Address.street_address(),
    "captcha" => "valid",
    "postal_code" => "12345678",
    "city" => Address.city(),
    "email" => Internet.email(),
    "lat" => Address.latitude(),
    "lon" => Address.longitude()
  }
  @valid_attrs %{
    "email" => @client_attrs["email"],
    "password" => @client_attrs["password"],
    "captcha" => "valid"
  }
  def client_fixture() do
    {:ok, client} = Mutator.create(@client_attrs)

    client
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create/2" do
    test "missing keys", %{conn: conn} do
      attrs =
        @valid_attrs
        |> Map.delete("email")

      conn =
        conn
        |> post(auth_path(conn, :create), attrs)

      actual = json_response(conn, 422)

      expected = %{
        "code" => 100,
        "message" => "Validation failed!",
        "errors" => [
          %{
            "code" => 104,
            "field" => "email",
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
        |> post(auth_path(conn, :create), attrs)

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
        |> post(auth_path(conn, :create), attrs)

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
        |> post(auth_path(conn, :create), attrs)

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
        |> post(auth_path(conn, :create), attrs)

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
        |> post(auth_path(conn, :create), @valid_attrs)

      actual = json_response(conn, 401)

      expected = %{
        "code" => 300,
        "message" => "Authorization failed!",
        "errors" => [
          %{
            "code" => 301,
            "message" => "Invalid credentials"
          }
        ]
      }

      assert actual == expected
    end

    test "wrong password", %{conn: conn} do
      client_fixture()

      attrs =
        @valid_attrs
        |> Map.put("password", "some other password")

      conn =
        conn
        |> post(auth_path(conn, :create), attrs)

      actual = json_response(conn, 401)

      expected = %{
        "code" => 300,
        "message" => "Authorization failed!",
        "errors" => [
          %{
            "code" => 301,
            "message" => "Invalid credentials"
          }
        ]
      }

      assert actual == expected
    end

    test "account is not activated", %{conn: conn} do
      client_fixture()

      conn =
        conn
        |> post(auth_path(conn, :create), @valid_attrs)

      actual = json_response(conn, 401)

      expected = %{
        "code" => 300,
        "message" => "Authorization failed!",
        "errors" => [
          %{
            "code" => 302,
            "message" => "Account not verified"
          }
        ]
      }

      assert actual == expected
    end

    test "should return a headless jwt", %{conn: conn} do
      client = client_fixture()
      Mutator.verify(%{"client_id" => client.id})

      conn =
        conn
        |> post(auth_path(conn, :create), @valid_attrs)

      %{"token" => token} = json_response(conn, 201)

      actual =
        token
        |> String.split(".")
        |> length()

      expected = 2

      assert actual == expected
    end

    test "should return a token with two hours of life time", %{conn: conn} do
      client = client_fixture()
      Mutator.verify(%{"client_id" => client.id})

      conn =
        conn
        |> post(auth_path(conn, :create), @valid_attrs)

      %{"token" => token} = json_response(conn, 201)

      actual =
        token
        |> String.split(".")
        |> List.first()
        |> Base.decode64!(padding: false)
        |> Jason.decode!()

      life_time = actual["exp"] - actual["iat"]

      assert life_time == 7200
    end
  end
end
