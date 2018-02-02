defmodule Herenow.ClientsTest do
  use Herenow.DataCase

  alias Herenow.Clients

  describe "clients" do
    alias Herenow.Clients.Client

    @valid_attrs %{address_number: "some address_number", cep: "some cep", city: "some city", email: "some email", is_company: "some is_company", is_verified: true, legal_name: "some legal_name", name: "some name", password: "some password", segment: "some segment", state: "some state", street: "some street"}
    @update_attrs %{address_number: "some updated address_number", cep: "some updated cep", city: "some updated city", email: "some updated email", is_company: "some updated is_company", is_verified: false, legal_name: "some updated legal_name", name: "some updated name", password: "some updated password", segment: "some updated segment", state: "some updated state", street: "some updated street"}
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
      assert client.address_number == "some address_number"
      assert client.cep == "some cep"
      assert client.city == "some city"
      assert client.email == "some email"
      assert client.is_company == "some is_company"
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
      assert client.address_number == "some updated address_number"
      assert client.cep == "some updated cep"
      assert client.city == "some updated city"
      assert client.email == "some updated email"
      assert client.is_company == "some updated is_company"
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
  end
end
