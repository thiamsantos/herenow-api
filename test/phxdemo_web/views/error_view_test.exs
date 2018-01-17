defmodule PhxdemoWeb.ErrorViewTest do
  use PhxdemoWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.json" do
    assert render(PhxdemoWeb.ErrorView, "404.json", []) ==
           %{message: "Not found"}
  end

  test "render 500.json" do
    assert render(PhxdemoWeb.ErrorView, "500.json", []) ==
           %{message: "Internal server error"}
  end

  test "render 401.json" do
    assert render(PhxdemoWeb.ErrorView, "401.json", %{reason: "reason"}) ==
           %{message: "reason"}
  end

  test "render any other" do
    assert render(PhxdemoWeb.ErrorView, "505.json", []) ==
           %{message: "Internal server error"}
  end
end
