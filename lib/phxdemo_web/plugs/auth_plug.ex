defmodule PhxdemoWeb.AuthPlug do
  @moduledoc """
  Authentication plug. It verifies the validity of the token.
  The token should be placed in the `Authorization` header using and Bearer strategy.
  """
  import Plug.Conn
  alias Phxdemo.Auth

  import Phoenix.Controller, only: [render: 4]

  def init(options) do
   options
  end

  def call(conn, _opts) do
    case authenticate(conn) do
      {:ok, claims} ->
        conn
        |> assign(:user_id, claims["user_id"])
      {:error, reason} ->
        conn
        |> render(PhxdemoWeb.ErrorView, "401.json", reason: reason)
        |> halt()
    end
  end

  defp authenticate(conn) do
    conn
    |> get_req_header("authorization")
    |> get_token
    |> Auth.verify_token
  end

  defp get_token(authorization_header) do
    trimmed_authorization = authorization_header
    |> Enum.at(0, "")
    |> String.trim()

    case Regex.run(~r/Bearer\s+(.*)$/i, trimmed_authorization) do
      [_, token] -> {:ok, token}
      _ -> {:error, "Invalid authorization"}
    end
  end
end
