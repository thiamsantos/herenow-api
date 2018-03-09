defmodule Herenow.AccessLogsTest do
  use Herenow.DataCase

  alias Herenow.AccessLogs

  describe "access_logs" do
    alias Herenow.AccessLogs.AccessLog

    @valid_attrs %{
      method: "some method",
      query_string: "some query_string",
      remote_ip: {192, 168, 0, 1},
      request_path: "some request_path",
      token_payload: %{"client_id" => 1},
      user_agent: "some user_agent"
    }

    def access_log_fixture(attrs \\ %{}) do
      {:ok, access_log} =
        attrs
        |> Enum.into(@valid_attrs)
        |> AccessLogs.log()

      access_log
    end

    test "log/1 with valid data creates a access_log" do
      assert {:ok, %AccessLog{} = access_log} = AccessLogs.log(@valid_attrs)
      assert access_log.method == @valid_attrs[:method]
      assert access_log.query_string == @valid_attrs[:query_string]
      assert access_log.remote_ip == @valid_attrs[:remote_ip]
      assert access_log.request_path == @valid_attrs[:request_path]
      assert access_log.token_payload == @valid_attrs[:token_payload]
      assert access_log.user_agent == @valid_attrs[:user_agent]
    end
  end
end
