defmodule HerenowWeb.ErrorViewTest do
  use HerenowWeb.ConnCase, async: true

  import Phoenix.View

  test "render/3 404.json" do
    actual = render(HerenowWeb.ErrorView, "404.json", [])
    expected = %{message: "Not found"}

    assert actual == expected
  end

  test "render/3 500.json" do
    actual = render(HerenowWeb.ErrorView, "500.json", [])
    expected = %{message: "Internal server error"}

    assert actual == expected
  end

  test "render/3 any other" do
    actual = render(HerenowWeb.ErrorView, "505.json", [])
    expected = %{message: "Internal server error"}

    assert actual == expected
  end
end
