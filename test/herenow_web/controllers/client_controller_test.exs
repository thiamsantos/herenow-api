defmodule HerenowWeb.ClientControllerTest do
  use HerenowWeb.ConnCase, async: true

  alias Faker.{Name, Address, Commerce, Internet, Company}
  alias Herenow.Clients.Storage.Mutator

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  @valid_attrs %{
    "street_number" => Address.building_number(),
    "is_company" => true,
    "name" => Name.name(),
    "password" => "some password",
    "legal_name" => Company.name(),
    "segment" => Commerce.department(),
    "state" => Address.state(),
    "street_name" => Address.street_name(),
    "captcha" => "valid",
    "postal_code" => "12345678",
    "city" => Address.city(),
    "email" => Internet.email()
  }

  def client_fixture(attrs \\ %{}) do
    {:ok, client} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Mutator.create()

    client
  end

  describe "create/2" do
    test "renders client when data is valid", %{conn: conn} do
      conn =
        conn
        |> post(client_path(conn, :create), @valid_attrs)

      client = json_response(conn, 201)

      assert is_integer(client["id"])
      assert client["street_number"] == @valid_attrs["street_number"]
      assert client["is_company"] == @valid_attrs["is_company"]
      assert client["name"] == @valid_attrs["name"]
      assert client["legal_name"] == @valid_attrs["legal_name"]
      assert client["segment"] == @valid_attrs["segment"]
      assert client["state"] == @valid_attrs["state"]
      assert client["street_name"] == @valid_attrs["street_name"]
      assert client["postal_code"] == @valid_attrs["postal_code"]
      assert client["city"] == @valid_attrs["city"]
      assert client["email"] == @valid_attrs["email"]
    end

    test "missing keys", %{conn: conn} do
      attrs =
        @valid_attrs
        |> Map.drop(["city", "email"])

      conn =
        conn
        |> post(client_path(conn, :create), attrs)

      actual = json_response(conn, 422)

      expected = %{
        "code" => 100,
        "message" => "Validation failed!",
        "errors" => [
          %{
            "code" => 104,
            "field" => "city",
            "message" => "can't be blank"
          },
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
        |> Map.put("email", 9)

      conn =
        conn
        |> post(client_path(conn, :create), attrs)

      actual = json_response(conn, 422)

      expected = %{
        "code" => 100,
        "message" => "Validation failed!",
        "errors" => [
          %{"code" => 102, "field" => "email", "message" => "is invalid"}
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
        |> post(client_path(conn, :create), attrs)

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

    test "email should be unique", %{conn: conn} do
      client = client_fixture()

      attrs =
        @valid_attrs
        |> Map.put("email", client.email)

      conn =
        conn
        |> post(client_path(conn, :create), attrs)

      actual = json_response(conn, 422)

      expected = %{
        "code" => 100,
        "message" => "Validation failed!",
        "errors" => [
          %{
            "code" => 107,
            "field" => "email",
            "message" => "has already been taken"
          }
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
        |> post(client_path(conn, :create), attrs)

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
        |> post(client_path(conn, :create), attrs)

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

    test "postal_code should have exact 8 characters", %{conn: conn} do
      attrs =
        @valid_attrs
        |> Map.put("postal_code", "1234")

      conn =
        conn
        |> post(client_path(conn, :create), attrs)

      actual = json_response(conn, 422)

      expected = %{
        "code" => 100,
        "message" => "Validation failed!",
        "errors" => [
          %{
            "code" => 103,
            "field" => "postal_code",
            "message" => "should be 8 character(s)"
          }
        ]
      }

      assert actual == expected
    end

    test "password should have at least 8 characters", %{conn: conn} do
      attrs =
        @valid_attrs
        |> Map.put("password", "abcdefg")

      conn =
        conn
        |> post(client_path(conn, :create), attrs)

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
  end
end
