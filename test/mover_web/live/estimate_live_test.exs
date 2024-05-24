defmodule MoverWeb.EstimateLiveTest do
  use MoverWeb.ConnCase

  import Phoenix.LiveViewTest
  import Mover.EstimatesFixtures

  @create_attrs %{
    origin: %{zip: "32003"},
    destination: %{zip: "32738"},
    cost_adjustment: 0.8
  }
  @invalid_attrs %{
    origin: %{zip: nil},
    destination: %{zip: nil},
    cost_adjustment: nil
  }

  defp create_estimate(_) do
    estimate = estimate_fixture()
    %{estimate: estimate}
  end

  describe "Index" do
    setup [:create_estimate]

    test "lists all estimates", %{conn: conn, estimate: estimate} do
      {:ok, _index_live, html} = live(conn, ~p"/")

      assert html =~ "Listing Estimates"
      assert html =~ estimate.origin.zip
    end

    test "saves new estimate", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/")

      assert index_live |> element("a", "New Estimate") |> render_click() =~
               "New Estimate"

      assert_patch(index_live, ~p"/new")

      assert index_live
             |> form("#estimate-form", estimate: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#estimate-form", estimate: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/")

      html = render(index_live)
      assert html =~ "Estimate created successfully"
      assert html =~ "32738"
    end

    test "deletes estimate in listing", %{conn: conn, estimate: estimate} do
      {:ok, index_live, _html} = live(conn, ~p"/")

      assert index_live |> element("#estimates-#{estimate.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#estimates-#{estimate.id}")
    end
  end
end
