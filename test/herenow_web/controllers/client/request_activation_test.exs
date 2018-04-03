defmodule HerenowWeb.Controllers.Client.RequestActivationTest do
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
    "email" => Internet.email()
  }
  @valid_attrs %{
    "captcha" => "valid",
    "email" => @client_attrs["email"]
  }

  def client_fixture() do
    {:ok, client} = Mutator.create(@client_attrs)

    client
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "request_activation/2" do
    test "missing keys", %{conn: conn} do
      attrs =
        @valid_attrs
        |> Map.delete("email")

      conn =
        conn
        |> post(client_path(conn, :request_activation), attrs)

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
        |> post(client_path(conn, :request_activation), attrs)

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
        |> post(client_path(conn, :request_activation), attrs)

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
        |> post(client_path(conn, :request_activation), attrs)

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
        |> post(client_path(conn, :request_activation), attrs)

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
        |> post(client_path(conn, :request_activation), @valid_attrs)

      actual = json_response(conn, 200)
      expected = %{"message" => "Email successfully sended!"}

      assert actual == expected
    end

    test "client registered", %{conn: conn} do
      client_fixture()

      conn =
        conn
        |> post(client_path(conn, :request_activation), @valid_attrs)

      actual = json_response(conn, 200)
      expected = %{"message" => "Email successfully sended!"}

      assert actual == expected
    end
  end
end
