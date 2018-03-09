defmodule HerenowWeb.Plugs.AccessLogPlug do
  @moduledoc """
  Log every request
  """
  alias Plug.Conn
  alias Herenow.AccessLogs
  alias Herenow.Core.Token

  def init(options) do
    options
  end

  def call(conn, _opts) do
    {:ok, _log} =
      AccessLogs.log(
        Map.merge(Map.from_struct(conn), %{
          user_agent: get_user_agent(conn),
          token_payload: get_token(conn)
        })
      )

    conn
  end

  def get_user_agent(conn) do
    conn
    |> Conn.get_req_header("user-agent")
    |> List.first()
  end

  defp get_token(conn) do
    trimmed_authorization =
      conn
      |> Conn.get_req_header("authorization")
      |> Enum.at(0, "")
      |> String.trim()

    case Regex.run(~r/Bearer\s+(.*)$/i, trimmed_authorization) do
      [_, token] -> Token.get_payload(token)
      _ -> nil
    end
  end
end
