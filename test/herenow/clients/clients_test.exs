defmodule Herenow.ClientsTest do
  use Herenow.DataCase

  alias Herenow.Clients

  describe "clients" do
    alias Herenow.Clients.Client

    @valid_attrs %{address_number: "54", cep: "88133050", city: "palhoça", email: "someemail@example.com", is_company: true, is_verified: true, legal_name: "some legal_name", name: "some name", password: "some password", segment: "some segment", state: "some state", street: "some street"}
    @update_attrs %{address_number: "227", cep: "88135000", city: "florianópolis", email: "someupdatedemail@gmail.com", is_company: false, is_verified: false, legal_name: "some updated legal_name", name: "some updated name", password: "some updated password", segment: "some updated segment", state: "some updated state", street: "some updated street"}
    @invalid_attrs %{address_number: nil, cep: nil, city: nil, email: nil, is_company: nil, is_verified: nil, legal_name: nil, name: nil, password: nil, segment: nil, state: nil, street: nil}

    def client_fixture(attrs \\ %{}) do
      {:ok, client} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Clients.create_client()

      client
    end

    test "list_clients/0 returns all clients" do
      client = client_fixture()
      assert Clients.list_clients() == [client]
    end

    test "get_client!/1 returns the client with given id" do
      client = client_fixture()
      assert Clients.get_client!(client.id) == client
    end

    test "create_client/1 with valid data creates a client" do
      assert {:ok, %Client{} = client} = Clients.create_client(@valid_attrs)
      assert client.address_number == "54"
      assert client.cep == "88133050"
      assert client.city == "palhoça"
      assert client.email == "someemail@example.com"
      assert client.is_company == true
      assert client.is_verified == true
      assert client.legal_name == "some legal_name"
      assert client.name == "some name"
      assert client.password == "some password"
      assert client.segment == "some segment"
      assert client.state == "some state"
      assert client.street == "some street"
    end

    test "create_client/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Clients.create_client(@invalid_attrs)
    end

    test "update_client/2 with valid data updates the client" do
      client = client_fixture()
      assert {:ok, client} = Clients.update_client(client, @update_attrs)
      assert %Client{} = client
      assert client.address_number == "227"
      assert client.cep == "88135000"
      assert client.city == "florianópolis"
      assert client.email == ""
      assert client.is_company == false
      assert client.is_verified == false
      assert client.legal_name == "some updated legal_name"
      assert client.name == "some updated name"
      assert client.password == "some updated password"
      assert client.segment == "some updated segment"
      assert client.state == "some updated state"
      assert client.street == "some updated street"
    end

    test "update_client/2 with invalid data returns error changeset" do
      client = client_fixture()
      assert {:error, %Ecto.Changeset{}} = Clients.update_client(client, @invalid_attrs)
      assert client == Clients.get_client!(client.id)
    end

    test "delete_client/1 deletes the client" do
      client = client_fixture()
      assert {:ok, %Client{}} = Clients.delete_client(client)
      assert_raise Ecto.NoResultsError, fn -> Clients.get_client!(client.id) end
    end

    test "change_client/1 returns a client changeset" do
      client = client_fixture()
      assert %Ecto.Changeset{} = Clients.change_client(client)
    end

    test "is_email_registered?/1 return a boolean" do
      client = client_fixture()
      assert true == Clients.is_email_registered?("someemail@example.com")
      assert false == Clients.is_email_registered?("someotheremail@gmail.com")
    end
  end
end
