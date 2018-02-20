defmodule Herenow.Core.Email.Template do
  @moduledoc """
  Utility to render HTML/text email templates
  """
  alias Herenow.Core.Email.Body

  @basepath "priv/email_templates"
  @extensions %{
    "html" => ".html",
    "text" => ".txt"
  }

  @spec render(atom, map) :: Body.t()
  def render(template, content) do
    html_body = do_render(template, "html", content)
    text_body = do_render(template, "text", content)

    %Body{html: html_body, text: text_body}
  end

  @spec do_render(atom, String.t(), map) :: String.t()
  defp do_render(template, type, content) do
    template
    |> Atom.to_string()
    |> concat(@extensions[type])
    |> get_path(type)
    |> File.read!()
    |> Mustache.render(content)
  end

  @spec concat(String.t(), String.t()) :: String.t()
  defp concat(left, right), do: left <> right

  @spec get_path(String.t(), String.t()) :: String.t()
  defp get_path(filename, type) do
    @basepath
    |> Path.join(type)
    |> Path.join(filename)
  end
end
