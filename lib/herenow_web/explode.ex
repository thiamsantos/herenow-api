defmodule HerenowWeb.Explode do
  @moduledoc """
  Utility for responding with standard HTTP/JSON error payloads
  """

  alias Plug.Conn

  @spec reply(Conn.t(), atom, List.t()) :: Conn.t()
  def reply(conn, type, errors) do
    status =
      type
      |> get_status_code()

    payload =
      type
      |> get_message()
      |> build_payload(type, errors)

    conn
    |> do_reply(status, payload)
  end

  def not_found(conn) do
    payload = %{
      "message" => "Not Found",
      "code" => get_error_code(:not_found)
    }

    conn
    |> do_reply(get_status_code(:not_found), payload)
  end

  @spec do_reply(Conn.t(), integer, map) :: Conn.t()
  defp do_reply(conn, status_code, payload) do
    conn
    |> Conn.put_resp_content_type("application/json")
    |> Conn.send_resp(status_code, Jason.encode!(payload))
    |> Conn.halt()
  end

  @spec build_payload(String.t(), atom, List.t()) :: map
  defp build_payload(message, type, errors) do
    %{
      "code" => get_error_code(type),
      "message" => message,
      "errors" => build_errors(errors)
    }
  end

  defp build_errors(errors) do
    errors
    |> Enum.map(&build_error/1)
  end

  defp build_error(error) do
    %{
      "message" => error["message"],
      "code" => get_error_code(error["type"]),
      "field" => Map.get(error, "field")
    }
  end

  defp get_message(:validation), do: "Validation failed!"

  defp get_status_code(:validation), do: 422
  defp get_status_code(:not_found), do: 404

  @spec get_error_code(atom) :: integer
  defp get_error_code(:validation), do: 100
  defp get_error_code(:invalid_captcha), do: 101
  defp get_error_code(:cast), do: 102
  defp get_error_code(:length), do: 103
  defp get_error_code(:required), do: 104
  defp get_error_code(:invalid_schema), do: 105
  defp get_error_code(:format), do: 106
  defp get_error_code(:unique), do: 107

  defp get_error_code(:not_found), do: 200
end
