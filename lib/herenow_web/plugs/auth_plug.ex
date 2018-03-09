defmodule HerenowWeb.AuthPlug do
  @moduledoc """
  Authentication plug. It verifies the validity of the token.
  The token should be placed in the `Authorization` header using and Bearer strategy.
  """
  import Plug.Conn
  alias Herenow.Clients.Authenticate.Token

  import Phoenix.Controller, only: [render: 4]

  def init(options) do
    options
  end

  def call(conn, _opts) do
    with {:ok, token} <- authenticate(conn),
         {:ok, claims} <- Token.verify(token) do
      assign(conn, :client_id, claims["client_id"])
    else
      {:error, message} ->
        conn
        |> put_status(:unauthorized)
        |> render(HerenowWeb.ErrorView, "401.json", message: message)
        |> halt()
    end
  end

  defp authenticate(conn) do
    conn
    |> get_req_header("authorization")
    |> get_token()
  end

  defp get_token(authorization_header) do
    trimmed_authorization =
      authorization_header
      |> Enum.at(0, "")
      |> String.trim()

    case Regex.run(~r/Bearer\s+(.*)$/i, trimmed_authorization) do
      [_, token] -> {:ok, token}
      _ -> {:error, "Invalid authorization"}
    end
  end
end
