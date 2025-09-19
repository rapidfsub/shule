defmodule PlatoWeb.ErrorJSONTest do
  use PlatoWeb.ConnCase, async: true

  test "renders 404" do
    assert PlatoWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert PlatoWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
