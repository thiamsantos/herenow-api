defmodule HerenowWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.
  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use HerenowWeb, :controller

  def call(conn, {:error, {status, message}}) do
    conn
    |> Explode.with(status, message)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> Explode.not_found()
  end
end
