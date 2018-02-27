defmodule Herenow.Core.Email.TemplateTest do
  use ExUnit.Case, async: true

  alias Faker.Name
  alias Herenow.Core.Email.Template

  test "render/2" do
    name = Name.name()

    body =
      Template.render(:test, %{
        "name" => name
      })

    assert body.html =~ "<div>Just a test #{name}</div>"
    assert body.text =~ "Just a test #{name}"
  end
end
