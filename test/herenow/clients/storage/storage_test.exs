defmodule Herenow.Clients.Storage.StorageTest do
  use Herenow.DataCase, async: true
  alias Herenow.Fixtures
  alias Herenow.Clients.Storage.{Client, Mutator, Loader}

  @valid_attrs Fixtures.client_attrs()
  @update_attrs Fixtures.client_attrs()
  @invalid_attrs %{
    "latitude" => nil,
    "longitude" => nil,
    "postal_code" => nil,
    "city" => nil,
    "email" => nil,
    "is_company" => nil,
    "is_verified" => nil,
    "legal_name" => nil,
    "name" => nil,
    "password" => nil,
    "segment" => nil,
    "state" => nil,
    "street_address" => nil
  }

  def client_fixture(attrs \\ %{}) do
    {:ok, client} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Mutator.create()

    client
  end

  describe "list_clients/0" do
    test "returns all clients" do
      client = client_fixture()
      assert Loader.all() == [client]
    end
  end

  describe "get_client!/1" do
    test "returns the client with given id" do
      client = client_fixture()
      assert Loader.get!(client.id) == client
    end
  end

  describe "create_client/1" do
    test "with valid data creates a client" do
      assert {:ok, %Client{} = client} = Mutator.create(@valid_attrs)
      assert client.latitude == @valid_attrs["latitude"]
      assert client.longitude == @valid_attrs["longitude"]
      assert client.postal_code == @valid_attrs["postal_code"]
      assert client.city == @valid_attrs["city"]
      assert client.email == @valid_attrs["email"]
      assert client.is_company == @valid_attrs["is_company"]
      assert client.legal_name == @valid_attrs["legal_name"]
      assert client.name == @valid_attrs["name"]
      assert client.segment == @valid_attrs["segment"]
      assert client.state == @valid_attrs["state"]
      assert client.street_address == @valid_attrs["street_address"]
    end

    test "with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Mutator.create(@invalid_attrs)
    end
  end

  describe "update_client/2" do
    test "with valid data updates the client" do
      client = client_fixture()
      assert {:ok, client} = Mutator.update(client, @update_attrs)
      assert %Client{} = client
      assert client.latitude == @update_attrs["latitude"]
      assert client.longitude == @update_attrs["longitude"]
      assert client.postal_code == @update_attrs["postal_code"]
      assert client.city == @update_attrs["city"]
      assert client.email == @update_attrs["email"]
      assert client.is_company == @update_attrs["is_company"]
      assert client.legal_name == @update_attrs["legal_name"]
      assert client.name == @update_attrs["name"]
      assert client.segment == @update_attrs["segment"]
      assert client.state == @update_attrs["state"]
      assert client.street_address == @update_attrs["street_address"]
    end

    test "with invalid data returns error changeset" do
      client = client_fixture()
      assert {:error, %Ecto.Changeset{}} = Mutator.update(client, @invalid_attrs)
      assert client == Loader.get!(client.id)
    end
  end

  describe "delete_client/1" do
    test "deletes the client" do
      client = client_fixture()
      assert {:ok, %Client{}} = Mutator.delete(client)
      assert_raise Ecto.NoResultsError, fn -> Loader.get!(client.id) end
    end
  end
end
