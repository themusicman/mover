defmodule MoverWeb.EstimateLiveTest do
  use MoverWeb.ConnCase

  import Phoenix.LiveViewTest
  import Mover.EstimatesFixtures

  @create_attrs %{
    origin_zip: "some origin_zip",
    destination_zip: "some destination_zip",
    distance: 42,
    standard_rate: 42,
    cost_adjustment: 120.5,
    cost: 42
  }
  @invalid_attrs %{
    origin_zip: nil,
    destination_zip: nil,
    distance: nil,
    standard_rate: nil,
    cost_adjustment: nil,
    cost: nil
  }

  defp create_estimate(_) do
    estimate = estimate_fixture()
    %{estimate: estimate}
  end

  describe "Index" do
    setup [:create_estimate]

    test "lists all estimates", %{conn: conn, estimate: estimate} do
      {:ok, _index_live, html} = live(conn, ~p"/estimates")

      assert html =~ "Listing Estimates"
      assert html =~ estimate.origin_zip
    end

    test "saves new estimate", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/estimates")

      assert index_live |> element("a", "New Estimate") |> render_click() =~
               "New Estimate"

      assert_patch(index_live, ~p"/estimates/new")

      assert index_live
             |> form("#estimate-form", estimate: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#estimate-form", estimate: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/estimates")

      html = render(index_live)
      assert html =~ "Estimate created successfully"
      assert html =~ "some origin_zip"
    end

    test "deletes estimate in listing", %{conn: conn, estimate: estimate} do
      {:ok, index_live, _html} = live(conn, ~p"/estimates")

      assert index_live |> element("#estimates-#{estimate.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#estimates-#{estimate.id}")
    end
  end
end
