defmodule HerenowWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common datastructures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      import HerenowWeb.Router.Helpers

      # The default endpoint for testing
      @endpoint HerenowWeb.Endpoint

      def authenticate_conn(conn, %{email: email, password: password}) do
        credentials = %{
          "email" => email,
          "password" => password,
          "captcha" => "valid"
        }

        conn = post(conn, auth_path(conn, :create), credentials)
        %{"token" => token} = json_response(conn, 201)

        conn
        |> recycle()
        |> put_req_header("authorization", "Bearer #{token}")
      end

      def authenticate_conn(conn) do
        alias Faker.{Name, Address, Commerce, Company, Internet}
        alias Herenow.Clients.Storage.Mutator

        attrs = %{
          "latitude" => Address.latitude(),
          "longitude" => Address.longitude(),
          "is_company" => true,
          "name" => Name.name(),
          "password" => "toortoor",
          "legal_name" => Company.name(),
          "segment" => Commerce.department(),
          "state" => Address.state(),
          "street_address" => Address.street_address(),
          "postal_code" => "12345678",
          "city" => Address.city(),
          "email" => Internet.email(),
          "lat" => Address.latitude(),
          "lon" => Address.longitude()
        }

        {:ok, client} = Mutator.create(attrs)
        {:ok, _verified_client} = Mutator.verify(%{"client_id" => client.id})

        authenticate_conn(conn, %{email: attrs["email"], password: attrs["password"]})
      end
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Herenow.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Herenow.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
