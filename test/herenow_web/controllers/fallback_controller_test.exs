defmodule HerenowWeb.FallbackControllerTest do
  use HerenowWeb.ConnCase

  alias HerenowWeb.FallbackController

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "call/2" do
    test "application error", %{conn: conn} do
      conn =
        conn
        |> FallbackController.call({:error, {:unprocessable_entity, "something wrong"}})

      actual = json_response(conn, 422)

      expected = %{
        "statusCode" => 422,
        "message" => "something wrong",
        "error" => "Unprocessable Entity"
      }

      assert actual == expected
    end

    test "not found", %{conn: conn} do
      conn =
        conn
        |> FallbackController.call({:error, :not_found})

      actual = json_response(conn, 404)

      expected = %{
        "statusCode" => 404,
        "error" => "Not Found",
        "message" => "Not Found"
      }

      assert actual == expected
    end
  end
end
