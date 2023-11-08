defmodule TrainingApiWeb.ErrorJSONTest do
  use TrainingApiWeb.ConnCase, async: true

  test "renders 404" do
    assert TrainingApiWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert TrainingApiWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
