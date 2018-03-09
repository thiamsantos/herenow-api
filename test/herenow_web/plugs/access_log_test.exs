defmodule HerenowWeb.Plugs.AccessLogTest do
  use HerenowWeb.ConnCase, async: true

  alias Herenow.Repo
  alias Herenow.Core.Token
  alias Herenow.AccessLogs.AccessLog
  alias HerenowWeb.Plugs.AccessLogPlug

  describe "call/2" do
    test "should save the access log to the database", %{conn: conn} do
      conn =
        conn
        |> AccessLogPlug.call(%{})

      results = Repo.all(AccessLog)
      assert length(results) == 1

      first = List.first(results)
      assert first.method == conn.method
      assert first.remote_ip == conn.remote_ip
      assert first.request_path == conn.request_path
    end

    test "should save the payload of a auth token", %{conn: conn} do
      token = Token.generate(%{"client_id" => 1}, "secret", 2)

      _conn =
        conn
        |> put_req_header("authorization", "Bearer " <> token)
        |> AccessLogPlug.call(%{})

      results = Repo.all(AccessLog)

      assert List.first(results).token_payload["client_id"] == 1
    end

    test "should save the user-agent", %{conn: conn} do
      user_agent =
        "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36"

      _conn =
        conn
        |> put_req_header("user-agent", user_agent)
        |> AccessLogPlug.call(%{})

      results = Repo.all(AccessLog)

      assert List.first(results).user_agent == user_agent
    end

    test "should save the query params" do
      query_string = "q=some%20search%20query"

      build_conn(:get, "/v1/api?" <> query_string)
      |> AccessLogPlug.call(%{})

      results = Repo.all(AccessLog)

      assert List.first(results).query_string == query_string
    end

    test "should save the request_path" do
      request_path = "/v1/api"

      build_conn(:get, request_path)
      |> AccessLogPlug.call(%{})

      results = Repo.all(AccessLog)

      assert List.first(results).request_path == request_path
    end

    test "should support different methods" do
      build_conn(:delete, "/v1/api/users/2")
      |> AccessLogPlug.call(%{})

      results = Repo.all(AccessLog)

      assert List.first(results).method == "DELETE"
    end

    test "should save multiple calls" do
      build_conn(:get, "/v1/api/users/2")
      |> AccessLogPlug.call(%{})

      build_conn(:post, "/v1/api/users")
      |> AccessLogPlug.call(%{})

      build_conn(:put, "/v1/api/users/2")
      |> AccessLogPlug.call(%{})

      build_conn(:patch, "/v1/api/users/2")
      |> AccessLogPlug.call(%{})

      build_conn(:delete, "/v1/api/users/2")
      |> AccessLogPlug.call(%{})

      results = Repo.all(AccessLog)

      assert length(results) == 5
    end
  end
end
