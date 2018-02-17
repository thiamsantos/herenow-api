defmodule HerenowWeb.ClientControllerTest do
  use HerenowWeb.ConnCase

  alias Faker.{Name, Address, Commerce, Internet, Company}

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

  describe "create/2" do
    test "renders client when data is valid", %{conn: conn} do
      conn = conn
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
  end
end
