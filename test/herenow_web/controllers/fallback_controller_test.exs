defmodule HerenowWeb.FallbackControllerTest do
  use HerenowWeb.ConnCase, async: true

  alias HerenowWeb.FallbackController

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "call/2" do
    test "not found", %{conn: conn} do
      conn =
        conn
        |> FallbackController.call({:error, :not_found})

      actual = json_response(conn, 404)

      expected = %{
        "code" => 200,
        "message" => "Not Found"
      }

      assert actual == expected
    end
  end
end
